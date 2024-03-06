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

int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);

void initHashTable()
{
  for (int i = 0; i < MEM_HASH_SIZE; i++)
  {
    table[i].startAddress = -1; // Use -1 to indicate an empty slot
    table[i].next = 0;
  }
}

void insert(uint startAddress, int length)
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
    newNode->length = length;
    newNode->next = table[index].next;
    table[index].next = newNode;
  }
}

memHashNode *search(int value)
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

// for debugging
void printHashTable()
{
  for (int i = 0; i < MEM_HASH_SIZE; i++)
  {
    printf(1, "Slot %d: ", i);
    if (table[i].startAddress != -1)
    {
      printf(1, "Address: %d, Pages: %d ", table[i].startAddress, table[i].length);
      memHashNode *node = table[i].next;
      while (node != 0)
      {
        printf(1, "Address: %d, Pages: %d", node->startAddress, node->length);
        node = node->next;
      }
    }
    printf("\n");
  }
}
uint wmap(uint addr, int length, int flags, int fd)
{
  struct proc *curproc = myproc();
  pde_t *pgdir = curproc->pgdir;

  if (hashInit = -1)
  {
    // initialize hash table
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
    else // if a page is allocated
    {
    }
  }

  return addr;
}

// int wunmap(uint addr)
// {
//   struct proc *curproc = myproc();
//   pde_t *pgdir = curproc->pgdir;
//   pte_t *pte = walkpgdir(pgdir, addr, 0); // modify page tables to make pages unaccessable

//   kfree(P2V(PTE_ADDR(*pte)));
// }

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
