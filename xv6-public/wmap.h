// Flags for wmap
#define MAP_PRIVATE 0x0001
#define MAP_SHARED 0x0002
#define MAP_ANONYMOUS 0x0004
#define MAP_FIXED 0x0008
// Flags for remap
#define MREMAP_MAYMOVE 0x1

// When any system call fails, returns -1
#define FAILED -1
#define SUCCESS 0

// for `getpgdirinfo`
#define MAX_UPAGE_INFO 32 // this is the maximum number of pages we can expect (this value was in the starter code)
struct pgdirinfo
{
    uint n_upages;           // the number of allocated physical pages in the process's user address space
    uint va[MAX_UPAGE_INFO]; // the virtual addresses of the allocated physical pages in the process's user address space
    uint pa[MAX_UPAGE_INFO]; // the physical addresses of the allocated physical pages in the process's user address space
};

// for `getwmapinfo`
#define MAX_WMMAP_INFO 16 // this is the maximum number of seperate wmap calls we can expect (this value was in the starter code)
#define MEM_HASH_SIZE 19  // we use 19 because the page size is divisible by 16,0x60000000 = 1610612736 decimal and 1610612736 + 4096n mod 19 is 7	18	10	2	13	5	16	8	0	11	3	14	6	17	9	1	12	4	15 7
struct wmapinfo
{
    int total_mmaps;                    // Total number of wmap regions
    int addr[MAX_WMMAP_INFO];           // Starting address of mapping
    int length[MAX_WMMAP_INFO];         // Size of mapping
    int n_loaded_pages[MAX_WMMAP_INFO]; // Number of pages physically loaded into memory
};

typedef struct memHashNode
{
    uint startAddress;
    int numPages;
    struct memHashNode *next;
} memHashNode;
