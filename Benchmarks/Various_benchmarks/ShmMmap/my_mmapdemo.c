/*
** mmapdemo.c -- demonstrates memory mapped files lamely.
http://beej.us/guide/bgipc/output/html/multipage/mmap.html
*/

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <errno.h>

int main(int argc, char *argv[])
{
	int fd, offset;
	char *data;
	char *duplicate_data;
	struct stat sbuf;
	int i;

	if (argc != 2) {
		fprintf(stderr, "usage: mmapdemo offset\n");
		exit(1);
	}

	if ((fd = open("testfile.txt", O_RDWR/*O_RDONLY*/)) == -1) {
		perror("open");
		exit(1);
	}

	if (stat("testfile.txt", &sbuf) == -1) {
		perror("stat");
		exit(1);
	}

	offset = atoi(argv[1]);
	if (offset < 0 || offset > sbuf.st_size-1) {
		fprintf(stderr, "mmapdemo: offset must be in the range 0-%d\n", (int)(sbuf.st_size-1));
		exit(1);
	}
	
	if ((data = mmap((caddr_t)0, sbuf.st_size, PROT_WRITE/*PROT_READ*/, MAP_PRIVATE/*MAP_SHARED*/, fd, 0)) == (caddr_t)(-1)) {
		perror("mmap");
		exit(1);
	}

	if ((duplicate_data = mmap((caddr_t)0, sbuf.st_size, PROT_WRITE/*PROT_READ*/, MAP_SHARED, fd, 0)) == (caddr_t)(-1)) {
		perror("mmap");
		exit(1);
	}

	for (i = 0; i < sbuf.st_size; i++)
	{
		printf("nO: byte at offset %d is '%c'\n", i, data[i]);
		printf("nD: byte at offset %d is '%c'\n", i, duplicate_data[i]);
	}

	for (i = 0; i < sbuf.st_size; i++)
	{
		data[i] = data[i] + 1;
		duplicate_data[i] = duplicate_data[i] + 1;
		printf("uO: byte at offset %d is '%c'\n", i, data[i]);
		printf("uD: byte at offset %d is '%c'\n", i, duplicate_data[i]);
	}

	return 0;
}
								
