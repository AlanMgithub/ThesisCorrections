#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include "rdhwr.c"

// some macros to make the code more understandable
//  regarding which pipe to use to a read/write operation
//
//  Parent: reads from P1_READ, writes on P1_WRITE
//  Child:  reads from P2_READ, writes on P2_WRITE
#define P1_READ     0
#define P2_WRITE    1
#define P2_READ     2
#define P1_WRITE    3

// the total number of pipe *pairs* we need
#define NUM_PIPES   2
#define DATA_SIZE 4*262144
#define MEMORY_BLOCKS 64

int main(int argc, char *argv[])
{
	int fd[2];
	char val[DATA_SIZE]; 
	int len, i;
	pid_t pid;


	for (i=0; i<DATA_SIZE; i++)
	{
		val[i] = rand();
	}

	if (pipe(fd) < 0)
	{
		perror("Failed to allocate pipe");
		exit(EXIT_FAILURE);
	}

	// fork() returns 0 for child process, child-pid for parent process.
	if ((pid = fork()) < 0)
	{
		perror("Failed to fork process");
		return EXIT_FAILURE;
	}

	// if the pid is zero, this is the child process
	if (pid == 0)
	{
		// used for output
		pid = getpid();

		// wait for parent to send us a value
		//printf("Second process ready to read memory\nTime: %lu\n", read_hw_counter());
		int j;
		char read_buffer[DATA_SIZE/MEMORY_BLOCKS];
		for(j=0; j<MEMORY_BLOCKS; j++)
		{
			len = read(fd[0], &read_buffer, DATA_SIZE/MEMORY_BLOCKS);
			if (len < 0)
			{
				perror("Child: Failed to read data from pipe");
				exit(EXIT_FAILURE);
			}
			else if (len == 0)
			{
				// not an error, but certainly unexpected
				fprintf(stderr, "Child: Read EOF from pipe");
			}
			else
			{
				int k;
				for (k=0; k<DATA_SIZE/MEMORY_BLOCKS; k++)
				{
					if (read_buffer[k] != val[(j*(DATA_SIZE/MEMORY_BLOCKS)) + k])
						printf("Memory Replication Error readbuffer[%d]=%d, val[%d]=%d\n", k, read_buffer[k], k, val[k]);
				}
			}
		}
		close(fd[0]);
		printf("Second process ending\nTime: %lu\n", read_hw_counter());

		return EXIT_SUCCESS;
	}

	pid = getpid();

	// send a value to the child

	int j;
	printf("First process begining to write memory\nTime: %lu\n", read_hw_counter());

	for(j=0; j<MEMORY_BLOCKS; j++)
	{
		if (write(fd[1], &val[j*DATA_SIZE/MEMORY_BLOCKS], DATA_SIZE/MEMORY_BLOCKS) != DATA_SIZE/MEMORY_BLOCKS)
		{
			perror("Parent: Failed to send value to child ");
			exit(EXIT_FAILURE);
		}
	}
	close(fd[1]);

	// wait for child termination
	wait(NULL);

	return EXIT_SUCCESS;
}
