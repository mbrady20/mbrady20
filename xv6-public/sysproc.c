#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "wmap.h"

// Declare hashtable
memHashNode table[MEM_HASH_SIZE];
memHashNode nodePool[MAX_WMMAP_INFO];
memHashNode *mostRecent;
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

void initHashTable()
{
  for (int i = 0; i < MEM_HASH_SIZE; i++)
  {
    table[i].startAddress = -1; // Use -1 to indicate an empty slot
    table[i].next = 0;
  }
}

void hashInsert(uint startAddress, int length, int numPages, int fd, int flags)
{
  int index = hash(startAddress);

  // If it's the first item in this slot
  if (table[index].startAddress == -1)
  {
    table[index].startAddress = startAddress;
    table[index].length = length;
    table[index].numPages = numPages;
    table[index].fd = fd;
    table[index].flags = flags;
    for (int i = 0; i < 12050; i++)
      table[index].loaded[i] = 0;
    mostRecent = &table[index];
    // No need to allocate for the first item as it uses the table's array directly
  }
  else
  {
    // Insert new item at the beginning of the list
    memHashNode *newNode = &nodePool[poolCounter++];
    newNode->startAddress = startAddress;
    newNode->length = length;
    newNode->numPages = numPages;
    newNode->fd = fd;
    newNode->flags = flags;
    newNode->next = table[index].next;
    for (int i = 0; i < 12050; i++)
      newNode->loaded[i] = 0;
    table[index].next = newNode;
    mostRecent = newNode;
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

int getpgdirinfo(struct proc *p, struct pgdirinfo *pdinfo)
{
  pde_t *pgdir;
  pte_t *pgtab;
  uint i, j, count = 0;

  pgdir = p->pgdir;

  for (i = 0; i < NPDENTRIES; i++)
  {
    if (pgdir[i] & PTE_P && pgdir[i] & PTE_U)
    {
      pgtab = (pte_t *)P2V(PTE_ADDR(pgdir[i]));
      for (j = 0; j < NPTENTRIES; j++)
      {
        if (pgtab[j] & PTE_P && pgtab[j] & PTE_U)
        {
          if (count < MAX_UPAGE_INFO)
          {
            pdinfo->va[count] = (i * PGSIZE * NPTENTRIES) + j * PGSIZE;
            pdinfo->pa[count] = PTE_ADDR(pgtab[j]);

            cprintf("va: %x, pa: %x\n", pdinfo->va[count], pdinfo->pa[count]);
          }
          count++;
        }
      }
    }
  }
  pdinfo->n_upages = count;
  return 0;
}

uint wmap(uint addr, int length, int flags, int fd)
{
  // struct proc *curproc = myproc();
  // pde_t *pgdir = curproc->pgdir;
  // struct file *file = curproc->ofile[fd];
  if (addr % 4096 != 0)
  {
    addr = PGROUNDDOWN(addr);
  }

  if (hashInit == -1)
  {
    initHashTable();
    hashInit = 1;
  }
  // Check if the length is valid
  if (length <= 0)
  {
    return -1;
  }
  int roundLength;
  if (length % PGSIZE != 0)
  {
    roundLength = length + (PGSIZE - (length % PGSIZE));
  }
  else
  {
    roundLength = length;
  }

  //  If MAP_FIXED flag is set
  if ((flags & MAP_FIXED))
  {
    // Check if the address is valid
    if (addr < 0x60000000 || addr >= 0x80000000)
    {
      //    cprintf("address invalid\n");
      return FAILED;
    }
    else if (pageInMappings(addr) != 0)
    {
      return FAILED;
    }
  }
  else
  {
    memHashNode *node = pageInMappings(addr);
    if (node == 0)
    {

      addr = mostRecent->startAddress + mostRecent->numPages * PGSIZE;
    }
    else
    {
      addr = node->startAddress + node->numPages * PGSIZE;
    }
    if (addr < 0x60000000 || addr >= 0x80000000)
    {
      addr = MMAPBASE;
    }
    int baseAddr = addr;

    do
    {
      int i;
      for (i = 0; i < roundLength; i += PGSIZE)
      {
        if (pageInMappings(addr + i) != 0)
          break;
      }
      if (i == roundLength)
        goto createMap;

      memHashNode *newNode = pageInMappings(addr + i);
      if (newNode == 0)
        addr += 0x1000;
      else
      {
        addr = newNode->startAddress + newNode->numPages * PGSIZE;
      }

    } while (baseAddr != addr);
  }

//   int i;
//   // Allocate physical memory and map it to the virtual address space
//   for (i = 0; i < roundLength; i += PGSIZE)
//   {

//     char *mem = kalloc();
//     if (mem == 0)
//     {
//       cprintf("mem invalid\n");
//       return -1;
//     }
//     // cprintf("kalloc good\n");

//     if (mappages(pgdir, (void *)addr + i, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
//     {
//       for (uint j = 0; j < i; j += PGSIZE)
//       {
//         pte_t *pte = walkpgdir(pgdir, (void *)(addr + (j)), 0); // modify page tables to make pages unaccessable, third argument indicates that a new page will not be created if a page is not found
//         kfree(P2V(PTE_ADDR(*pte)));
//         *pte = 0;
//       }
//       cprintf("map invalid\n");
//       return FAILED;
//     }

//     //  cprintf("page %p good\n", i);
//   }
//   if (!(flags & MAP_ANONYMOUS))
//   {

//     int readBytes = fileread(file, (void *)addr, length);
//     if (readBytes < 0)
//     {
//       // Handle read failure
//       return -1;
//     }
//   }
//   // memory successfully added bc no errors

//   //  cprintf("addr: %x, length:%d\n", addr, length);
//   // cprintf("FIXED: addr: %x, length:%d\n", addr, i / PGSIZE);
//   hashInsert(addr, length, (roundLength / PGSIZE), fd, flags);
//   return addr;
// }
// else
// { // brute force!!!

//   //  cprintf("brute force\n");
//   if (addr < 0x60000000 || addr >= 0x80000000)
//   {
//     addr = MMAPBASE;
//   }
//   else if (addr % 4096 != 0)
//   {
//     addr = PGROUNDDOWN(addr);
//   }

//   uint beginAddr = addr;
//   int numAttempts = 0;
//   int i;
//   do
//   {
//     if (addr >= KERNBASE)
//     {
//       addr = MMAPBASE;
//     }
//     // cprintf("addr: %x\n", addr);

//     //     cprintf("addr good\n");

//     // Allocate physical memory and map it to the virtual address space
//     //   cprintf("addr: %x\n", addr);
//     for (i = 0; i < roundLength; i += PGSIZE)
//     {
//       char *mem = kalloc();
//       if (mem == 0)
//       {
//         cprintf("mem invalid\n");
//         return -1;
//       }
//       //      cprintf("kalloc good\n");

//       if (mappages(pgdir, (void *)addr + i, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
//       {
//         //    cprintf("mappages failed\n");
//         for (uint j = 0; j < i; j += PGSIZE)
//         {
//           // cprintf("i: %d, j: %d\n", i, j);
//           pte_t *pte = walkpgdir(pgdir, (void *)(addr + (j)), 0); // modify page tables to make pages unaccessable, third argument indicates that a new page will not be created if a page is not found
//           kfree(P2V(PTE_ADDR(*pte)));
//           *pte = 0;
//         }

//         break;
//       }
//       else if (i >= length - PGSIZE)
//       {
//         goto createMap;
//       }

//       //   cprintf("page %p good\n", i);
//     }

//     // memory successfully added bc no errors
//     numAttempts++;
//     if (hashSearch(addr) == 0)
//       addr += 0x1000;
//     else
//     {
//       addr += hashSearch(addr)->numPages * PGSIZE;
//     }
//     //  cprintf("addr: %x, length:%d\n", addr, length);
//     // cprintf("addr: %x, length:%d\n", addr, length / PGSIZE);

//   } while (addr != beginAddr);

//   cprintf("hello\n");
//   return -1;
// createMap:
//   if (!(flags & MAP_ANONYMOUS))
//   {

//     int readBytes = fileread(file, (void *)addr, length);
//     if (readBytes < 0)
//     {
//       // Handle read failure
//       return FAILED;
//     }
//   }
createMap:
  cprintf("numpages %d\n", roundLength / PGSIZE);
  hashInsert(addr, length, (roundLength / PGSIZE), fd, flags);
  //   cprintf("addr: %x, length:%d\n", addr, length / PGSIZE);
  return addr;
  //  }
}

int wunmap(uint addr)
{
  struct proc *curproc = myproc();
  pde_t *pgdir = curproc->pgdir;

  memHashNode *node = hashSearch(addr);

  if (node == 0)
    return FAILED; // no memory at this starting address

  for (uint i = 0; i < node->numPages; ++i)
  {
    pte_t *pte = walkpgdir(pgdir, (void *)(addr + (i * PGSIZE)), 0); // modify page tables to make pages unaccessable, third argument indicates that a new page will not be created if a page is not found
    kfree(P2V(PTE_ADDR(*pte)));
    *pte = 0;
  }

  removeValue(addr); // it says in the writeup to remove any metadata we stored first ... I don't see a reason we can't do it after as of now.
  return 1;
}

/*
int getpgdirinfo(struct pgdirinfo *pdinfo)
{
  memset(pdinfo, 0, sizeof(struct pgdirinfo));
  struct proc *curproc = myproc();
  pde_t *pgdir = curproc->pgdir;

  for (int i = 0; i < NPDENTRIES; ++i)
  {
    if (pgdir[i] & PTE_U)
    {
      pdinfo->n_upages++;
      pdinfo->pa[i] = PTE_ADDR(pgdir[i]);
      pdinfo->va[i] = PTE_ADDR(P2V(PTE_ADDR(pgdir[i])));
    }
  }

  return 0;
} */

int getwmapinfo(struct wmapinfo *wminfo)
{
  if (hashInit == -1)
  {
    initHashTable();
    hashInit = 0;
    memset(wminfo, 0, sizeof(struct wmapinfo));
    return 0;
  }
  int pageCount = 0;
  memset(wminfo, 0, sizeof(struct wmapinfo));
  for (int i = 0; i < MEM_HASH_SIZE; i++)
  {
    if (table[i].startAddress != -1)
    {
      wminfo->addr[pageCount] = table[i].startAddress;
      wminfo->length[pageCount] = table[i].length;
      int numLoadedPages = 0;
      cprintf("length: %d\n", table[i].numPages);
      for (int j = 0; j < table[i].numPages; j++)
      {

        if (table[i].loaded[j] == 1)
        {
          numLoadedPages++;
        }
      }
      wminfo->n_loaded_pages[pageCount++] = numLoadedPages;
      cprintf("Num loaded pages: %d\n", numLoadedPages);
      wminfo->total_mmaps += 1;
      memHashNode *node = table[i].next;
      while (node != 0)
      {
        wminfo->addr[pageCount] = node->startAddress;
        wminfo->length[pageCount] = node->length;
        numLoadedPages = 0;
        for (int j = 0; j < node->numPages; j++)
        {
          if (node->loaded[j] == 1)
          {
            numLoadedPages++;
          }
        }
        wminfo->n_loaded_pages[pageCount++] = numLoadedPages;
        wminfo->total_mmaps += 1;
        node = node->next;
      }
    }
  }
  return 0;
}

memHashNode *pageInMappings(int address)
{
  memHashNode *node = hashSearch(address);
  if (node != 0)
  {
    return node;
  }
  else
  {
    for (int i = 0; i < MEM_HASH_SIZE; i++)
    {
      node = &table[i];

      while (node != 0)
      {
        if (node->startAddress <= address && address < node->startAddress + node->numPages * PGSIZE)
        {
          return node;
        }
        node = node->next;
      }
    }
  }

  return 0;
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

int sys_getpgdirinfo(void)
{
  struct proc *curproc = myproc();

  struct pgdirinfo *pginfo;
  if (argptr(0, (void *)&pginfo, sizeof(struct pgdirinfo)) < 0)
    return -1; // failure

  return getpgdirinfo(curproc, pginfo);
}

int sys_getwmapinfo(void)
{
  struct wmapinfo *myMapInfo;
  if (argptr(0, (void *)&myMapInfo, sizeof(struct wmapinfo)) < 0)
    return -1; // failure

  return getwmapinfo(myMapInfo);
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
