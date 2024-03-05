#include "types.h"
#include "user.h"
#include "fcntl.h"

#define PGSIZE 4096

int
main(int argc, char *argv[])
{
  uint addr = 0x60000000;
  int length = 8192; // Two pages
  int flags = MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS;
  int fd = -1;

  // Call wmap
  addr = wmap(addr, length, flags, fd);
  if(addr < 0){
    printf(1, "wmap failed\n");
    exit();
  }

  // Write to the mapped memory
  char *ptr = (char*)addr;
  for(int i = 0; i < length; i++)
    ptr[i] = i % 256;

  // Read from the mapped memory and check the values
  for(int i = 0; i < length; i++){
    if(ptr[i] != i % 256){
      printf(1, "memory check failed at %d\n", i);
      exit();
    }
  }

  printf(1, "memory check passed\n");
  exit();
}