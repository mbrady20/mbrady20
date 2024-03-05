#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}

int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm);

uint
wmap(uint addr, int length, int flags, int fd)
{
  struct proc *curproc = myproc();
  pde_t *pgdir = curproc->pgdir;

  // Check if the address is valid
  if(addr < 0x60000000 || addr >= 0x80000000 || addr % PGSIZE != 0)
    return -1;

  // Check if the length is valid
  if(length <= 0)
    return -1;

  // Allocate physical memory and map it to the virtual address space
  for(int i = 0; i < length; i += PGSIZE){
    char *mem = kalloc();
    if(mem == 0)
      return -1;

    if(mappages(pgdir, (void *)addr + i, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0)
      return -1;
  }

  return addr;
}

int sys_wmap(void)
{
  // CODE HERE
  uint addr;
  int length, flags, fd;

  if(argint(0, (int*)&addr) < 0 || argint(1, &length) < 0 ||
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

int
sys_fork(void)
{
  return fork();
}

int
sys_getfilename(void)
{
  int pfd[1];
  struct file * pf[1];
  int fd;

  char * buf = {"\0"};

  int n;

  if (argfd(0, pfd, pf) == -1) {
    return -1;
  }

  argint(0, &fd);
  if (argstr(1, &buf)) {
    return -1;
  } 
  argint(2, &n);

  getfilename(fd, buf, n);
	return 0;
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
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
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
