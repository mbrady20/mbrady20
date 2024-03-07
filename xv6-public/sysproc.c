#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "wmap.h"

// typedef struct memHashNode
// {
//     int data;
//     struct Node *next;
// } memHashNode;

// Declare hashtable
memHashNode table[MAX_WMMAP_INFO];
memHashNode nodePool[MEM_HASH_SIZE];
int hashInit = -1;
int poolCounter = 0;

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;

  if (argint(n, &fd) < 0)
    return -1;
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    return -1;
  if (pfd)
    *pfd = fd;
  if (pf)
    *pf = f;
  return 0;
}

// Hash function to convert a key to an index
int hash(int key)
{
  return key % MEM_HASH_SIZE;
}

static pte_t *walkpgdir(pde_t *pgdir, const void *va, int alloc);
int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);

void initHashTable()
{
  for (int i = 0; i < MAX_WMMAP_INFO; i++)
  {
    table[i].startAddress = -1; // Use -1 to indicate an empty slot
    table[i].next = 0;
  }
}

void hashInsert(uint startAddress, int numPages)
{
  int index = hash(startAddress);

  // If it's the first item in this slot
  if (table[index].startAddress == -1)
  {
    table[index].startAddress = startAddress;
    // No need to allocate for the first item as it uses the table's array directly
  }
  else
  {
    // Insert new item at the beginning of the list
    memHashNode *newNode = &nodePool[poolCounter++];
    newNode->startAddress = startAddress;
    newNode->numPages = numPages;
    newNode->next = table[index].next;
    table[index].next = newNode;
  }
}

memHashNode *hashSearch(int value)
{
  int index = hash(value);
  memHashNode *node = &table[index];
  while (node != 0)
  {
    if (node->startAddress == value)
    {
      return node;
    }
    node = node->next;
  }
  return 0;
}

int removeValue(int startAddress)
{
  int index = hash(startAddress);
  memHashNode *node = &table[index];
  memHashNode *prev = 0;

  // Special case for removing the first node (dummy head)
  if (node->startAddress == startAddress)
  {
    if (node->next != 0)
    { // If there's another node in the list, move its data up
      memHashNode *temp = node->next;
      node->startAddress = temp->startAddress;
      node->next = temp->next;
      // No actual deletion in static memory, but we can consider reusing nodes or marking them
    }
    else
    {
      // Simply mark this slot as empty
      node->startAddress = -1;
      node->next = 0;
    }
    return 1;
  }

  // Traverse the list to find the node with the target value
  while (node != 0 && node->startAddress != startAddress)
  {
    prev = node;
    node = node->next;
  }

  // If the node was not found, return
  if (node == 0)
    return -1;

  // Re-link the previous node to skip the node being removed
  if (prev != 0)
  {
    prev->next = node->next;
  }
  return 1;
}

// for debugging
// void printHashTable()
// {
//   for (int i = 0; i < MEM_HASH_SIZE; i++)
//   {
//     printf(1, "Slot %d: ", i);
//     if (table[i].startAddress != -1)
//     {
//       printf(1, "Address: %d, Pages: %d ", table[i].startAddress, table[i].numPages);
//       memHashNode *node = table[i].next;
//       while (node != 0)
//       {
//         printf(1, "Address: %d, Pages: %d", node->startAddress, node->numPages);
//         node = node->next;
//       }
//     }
//     printf("\n");
//   }
// }

uint wmap(uint addr, int length, int flags, int fd)
{
  struct proc *curproc = myproc();
  pde_t *pgdir = curproc->pgdir;

  if (hashInit == -1)
  {
    initHashTable();
    hashInit = 1;
  }

  // Check if the address is valid
  if (addr < 0x60000000 || addr >= 0x80000000 || addr % PGSIZE != 0)
    return -1;

  // Check if the length is valid
  if (length <= 0)
    return -1;

  // Allocate physical memory and map it to the virtual address space
  for (int i = 0; i < length; i += PGSIZE)
  {
    char *mem = kalloc();
    if (mem == 0)
      return -1;

    if (mappages(pgdir, (void *)addr + i, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
      return -1;
    else if (i >= 1)
    {
      // first i pages allocated successfully but now need to be deallocated bc entire block not open
    }
  }

  // memory successfully added bc no errors
  hashInsert(addr, length / PGSIZE);
  return addr;
}

int wunmap(uint addr)
{
  struct proc *curproc = myproc();
  pde_t *pgdir = curproc->pgdir;

  memHashNode *node = hashSearch(addr);

  if (node == 0)
    return -1; // no memory at this starting address

  for (uint i = 0; i < node->numPages; ++i)
  {
    pte_t *pte = walkpgdir(pgdir, (void *)(addr + (i * PGSIZE)), 0); // modify page tables to make pages unaccessable, third argument indicates that a new page will not be created if a page is not found
    kfree(P2V(PTE_ADDR(*pte)));
    *pte = 0;
  }

  removeValue(addr); // it says in the writeup to remove any metadata we stored first ... I don't see a reason we can't do it after as of now.
  return 1;
}

int sys_wmap(void)
{
  // CODE HERE
  uint addr;
  int length, flags, fd;

  if (argint(0, (int *)&addr) < 0 || argint(1, &length) < 0 ||
      argint(2, &flags) < 0 || argint(3, &fd) < 0)
    return -1;

  return wmap(addr, length, flags, fd);
}

int sys_wremap(void)
{
  // CODE HERE
  return 0;
}

int sys_wunmap(void)
{
  // CODE HERE
  return 0;
}

int sys_fork(void)
{
  return fork();
}

int sys_getfilename(void)
{
  int pfd[1];
  struct file *pf[1];
  int fd;

  char *buf = {"\0"};

  int n;

  if (argfd(0, pfd, pf) == -1)
  {
    return -1;
  }

  argint(0, &fd);
  if (argstr(1, &buf))
  {
    return -1;
  }
  argint(2, &n);

  getfilename(fd, buf, n);
  return 0;
}

int sys_exit(void)
{
  exit();
  return 0; // not reached
}

int sys_wait(void)
{
  return wait();
}

int sys_kill(void)
{
  int pid;

  if (argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int sys_getpid(void)
{
  return myproc()->pid;
}

int sys_sbrk(void)
{
  int addr;
  int n;

  if (argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

int sys_sleep(void)
{
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
