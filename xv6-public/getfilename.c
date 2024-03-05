#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
    int fileID = open(argv[1], 256);
    char message[256] = {"\0"};
    getfilename(fileID, message, 256);
    //int *pfd;
    //int **pf;
    //if (argfd(1, &pfd, &pf) == -1) {
    // return -1;
    //}

     printf(1, "XV6_TEST_OUTPUT Open filename: %s\n", 
        message);
    exit();
}
