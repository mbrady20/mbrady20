#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"
#include "wmap.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
  int i;

  for (i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void idtinit(void)
{
  lidt(idt, sizeof(idt));
}

void fileseek(struct file *f, int offset);
// PAGEBREAK: 41
void trap(struct trapframe *tf)
{
  if (tf->trapno == T_SYSCALL)
  {
    if (myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if (myproc()->killed)
      exit();
    return;
  }

  switch (tf->trapno)
  {
  case T_IRQ0 + IRQ_TIMER:
    if (cpuid() == 0)
    {
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE + 1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
  // page fault occured
  case T_PGFLT:
    int pageAddr = rcr2(); // address of the page that caused the page fault
    memHashNode *node = pageInMappings(pageAddr);
    pde_t *pgdir = myproc()->pgdir;

    if (node != 0)
    {
      int offset = pageAddr - node->startAddress;
      offset = offset - (offset % PGSIZE);
      pageAddr = node->startAddress + offset; // page address aligned to PGSIZE
      pte_t *pte = walkpgdir(pgdir, (char *)pageAddr, 0);
      if (pte == 0)
      {
        char *mem = kalloc();
        if (mem == 0)
        { // no memory available
          goto segFault;
        }
        memset(mem, 0, PGSIZE); // initialize the page with 0

        if (node->flags & MAP_ANONYMOUS) // page is anonymous
        {
          mappages(pgdir, (void *)pageAddr, PGSIZE, V2P(mem), PTE_W | PTE_U);
          ++node->loadedPages;
        }
        else if (!(node->flags & MAP_ANONYMOUS)) // page is file backed
        {
          char *mem = kalloc();
          if (mem == 0)
            goto segFault;

          struct file *f = myproc()->ofile[node->fd]; // get the file struct from fd

          if (f == 0)
            goto segFault;

              // fileseek(f, 0); // set the offset to the start of the file
          int n = fileread(f, mem, PGSIZE); // read memory from file to mem

          // If the file is smaller than a page, zero out the rest of the page
          if (n < PGSIZE)
            memset(mem + n, 0, PGSIZE - n);

          mappages(pgdir, (void *)pageAddr, PGSIZE, V2P(mem), PTE_W | PTE_U);
          ++node->loadedPages;
        }
      }
    }
    else
    {
    segFault:
      cprintf("Segmentation Fault\n");
      exit();
    }
    break;

  // PAGEBREAK: 13
  default:
    if (myproc() == 0 || (tf->cs & 3) == 0)
    {
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if (myproc() && myproc()->state == RUNNING &&
      tf->trapno == T_IRQ0 + IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
    exit();
}
