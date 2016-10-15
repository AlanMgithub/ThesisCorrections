#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <errno.h>
#include <time.h>
#include <sys/time.h>
#include <string.h>

struct timeval  time_begin_main,
                time_end_main
;

int main(int argc, char *argv[]) {  
    int fd; // file descriptor to open /dev/mem
    struct timespec time1, time2;
    fd = open("/dev/mem", O_RDWR|O_SYNC);
    if (fd == -1) {
        printf("\n Error opening /dev/mem");
        return 0;
    }
    struct timespec t1, t2;
    char *addr = (char*)mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_SHARED/*MAP_PRIVATE*/, fd, 0xfb000000/*0x20000*/);
    if (addr == MAP_FAILED) {
      printf("\n mmap() failed");
    } 
    // Begin accessing 
    char *addr1 = addr;
    char *addr2 = addr1 + 64; // add cache line

    unsigned int i = 0;
    unsigned int j = 0;
    // Begin accessing uncached region

    gettimeofday(&time_begin_main, NULL); // GET TIME
    while(j < 8192){
        i = 0;
        while(i < 500) {
            *addr1 = *addr2 + i;
            *addr2 = *addr1 + i;
            i = i+1;
        }
        j = j + 64;
        addr2 = addr1 + j;
    }
    gettimeofday(&time_end_main, NULL); // GET TIME

    double total_time = (double)(time_end_main.tv_usec - time_begin_main.tv_usec)/1000000
                      + (double)(time_end_main.tv_sec - time_begin_main.tv_sec);
    total_time = total_time*1000000;

    if (munmap(addr, 8192) == -1) {
         printf("\n Unmapping failed");
         return 0;
    }
    printf("Success...... Time = %.0f\n", total_time);
    return 0;
}
