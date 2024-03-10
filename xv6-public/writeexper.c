#include "types.h"
#include "user.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
    int fd;
    char *filename = "newfile.txt";
    char *data = "Hello, World!\n";

    fd = open(filename, O_CREATE | O_WRONLY);
    if(fd < 0) {
        printf(1, "Failed to create file %s\n", filename);
        exit();
    }

    if(write(fd, data, strlen(data)) != strlen(data)) {
        printf(1, "Failed to write to file %s\n", filename);
        exit();
    }

    if(write(fd, data, strlen(data)) != strlen(data)) {
        printf(1, "Failed to write to file %s\n", filename);
        exit();
    }

    printf(1, "Successfully wrote to file %s\n", filename);

    close(fd);

    char *newdata = "New content!\n";

    fd = open(filename, O_WRONLY);
    if(fd < 0) {
        printf(1, "Failed to open file %s\n", filename);
        exit();
    }

    if(write(fd, newdata, strlen(data)) != strlen(data)) {
        printf(1, "Failed to write to file %s\n", filename);
        exit();
    }

    printf(1, "Successfully wrote to file %s\n", filename);

    close(fd);

    exit();
}