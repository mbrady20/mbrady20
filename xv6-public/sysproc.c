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

void overwrite_file(struct file *f, char *data, int len);

struct file
{
  enum
  {
    FD_NONE,
    FD_PIPE,
    FD_INODE
  } type;
  int ref; // reference count
  char readable;
  char writable;
  struct pipe *pipe;
  struct inode *ip;
  uint off;
  char *name;
};

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
    table[index].loadedPages = 0;
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
    newNode->loadedPages = 0;
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
    // Mark this node as empty
    node->startAddress = -1;
    node->next = 0;
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
          }
          count++;
        }
      }
    }
  }
  pdinfo->n_upages = count;
  return 0;
}

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
      wminfo->n_loaded_pages[pageCount++] = table[i].loadedPages;
      wminfo->total_mmaps += 1;
      memHashNode *node = table[i].next;
      while (node != 0)
      {
        wminfo->addr[pageCount] = node->startAddress;
        wminfo->length[pageCount] = node->length;
        wminfo->n_loaded_pages[pageCount++] = node->loadedPages;
        wminfo->total_mmaps += 1;
        node = node->next;
      }
    }
  }
  return 0;
}

uint wmap(uint addr, int length, int flags, int fd)
{

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
createMap:
  hashInsert(addr, length, (roundLength / PGSIZE), fd, flags);
  return addr;
}

int wunmap(uint addr)
{
  struct proc *curproc = myproc();
  pde_t *pgdir = curproc->pgdir;
  struct file *file;
  pte_t *pte;
  uint pa;

  // Find the mapping that starts at the given address
  memHashNode *node = pageInMappings(addr);
  if (node == 0)
  {
    return -1; // No such mapping exists
  }

  // If the mapping is file-backed and has the MAP_SHARED flag, write the memory data back to the file
  if (!(node->flags & MAP_ANONYMOUS) && (node->flags & MAP_SHARED))
  {
    file = curproc->ofile[node->fd];
    overwrite_file(file, (char *)node->startAddress, node->length); // like filewrite(), but overwrites files instead of adding to them
  }

  // Remove the mapping from the process's virtual address space
  removeValue(addr);

  for (uint a = addr; a < addr + node->length; a += PGSIZE)
  {
    // Modify the page table so that the user can no longer access those pages
    pte = walkpgdir(pgdir, (char *)a, 0);
    if (pte <= 0)
    {
      break;
    }
    pa = PTE_ADDR(*pte);
    if (pa <= 0)
    {
      break;
    }
    char *v = P2V(pa);
    kfree(v);
  }

  for (uint a = addr; a < addr + node->length; a += PGSIZE)
  {
    pte = walkpgdir(pgdir, (char *)a, 0);
    *pte = 0;
  }

  return 0; // Success
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

int wunmap_partial(uint addr, int length)
{
  struct proc *curproc = myproc();
  pde_t *pgdir = curproc->pgdir;
  pte_t *pte;

  for (uint a = addr; a < addr + length; a += PGSIZE)
  {
    pte = walkpgdir(pgdir, (char *)a, 0);
    if (pte == 0)
    {
      continue; // Page was not present
    }
    *pte = 0;
  }

  return 0; // Success
}

int can_grow_in_place(uint oldaddr, int oldsize, int newsize)
{
  // Check each page in the new range
  for (uint a = oldaddr + oldsize; a < oldaddr + newsize; a += PGSIZE)
  {
    // If the page is in any mapping, return 0
    if (pageInMappings(a) != 0)
    {
      return 0; // Page is already in use
    }
  }

  return 1; // All pages are available
}

uint wremap(uint oldaddr, int oldsize, int newsize, int flags)
{
  memHashNode *node = pageInMappings(oldaddr);

  // Check if the old mapping exists
  if (node == 0 || node->length != oldsize)
  {
    return -1; // No such mapping exists or size mismatch
  }

  // If newsize is less than oldsize, shrink the mapping
  if (newsize < oldsize)
  {
    // Unmap the pages that are no longer needed
    wunmap_partial(oldaddr + newsize, oldsize - newsize);
    node->length = newsize;
    return oldaddr;
  }

  // If newsize is greater than oldsize, try to grow the mapping
  if (newsize > oldsize)
  {
    // Try to grow in-place
    if (can_grow_in_place(oldaddr, oldsize, newsize))
    {
      node->length = newsize;
      return oldaddr;
    }

    // If can't grow in-place and MREMAP_MAYMOVE is set, move the mapping
    if (flags & MREMAP_MAYMOVE)
    {
      uint newaddr = wmap(MMAPBASE, newsize, node->flags - MAP_FIXED, node->fd);
      if (newaddr != -1)
      {
        memmove((void *)newaddr, (void *)oldaddr, oldsize);
        wunmap(oldaddr);
        return newaddr;
      }
    }
  }

  // If we reach here, wremap failed
  return -1;
}

int sys_wremap(void)
{
  // CODE HERE
  uint oldaddr;
  int oldsize, newsize, flags;

  if (argint(0, (int *)&oldaddr) < 0 || argint(1, &oldsize) < 0 ||
      argint(2, &newsize) < 0 || argint(3, &flags) < 0)
    return -1;
  return wremap(oldaddr, oldsize, newsize, flags);
}

int sys_wunmap(void)
{
  // CODE HERE
  uint addr;

  if (argint(0, (int *)&addr) < 0)
    return -1;
  return wunmap(addr);
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
  int pid = fork();

  return pid;
}

int forkHelper(void)
{
  for (int i = 0; i < MEM_HASH_SIZE; i++)
  {
    memHashNode *node = &table[i];
    while (node != 0 && node->startAddress != -1)
    {
      hashInsert(node->startAddress, node->length, node->numPages, node->fd, node->flags);
      node = node->next;
    }
  }
  return 0;
}

int exitHelper(void)
{
  // Remove all memory mappings
  for (int i = 0; i < MEM_HASH_SIZE; i++)
  {
    memHashNode *node = &table[i];
    while (node != 0 && node->startAddress != -1)
    {
      removeValue(node->startAddress);
      node = node->next;
    }
  }
  return 0;
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
  // Remove all memory mappings
  memHashNode *node = table;
  while (node != 0)
  {
    memHashNode *next = node->next;
    wunmap(node->startAddress);
    node = next;
  }
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
