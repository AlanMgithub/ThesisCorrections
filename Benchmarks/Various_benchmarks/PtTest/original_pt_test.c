#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
//#include<math.h>
//#include<time.h>
#include"rdhwr.c"
#include"capability.h"

volatile int global_counter = 0;
//volatile int shared_array_1[5] = {1,2,3,4,5};
//volatile int shared_array_2[5] = {0,0,0,0,0};
//pthread_mutex_t mutex_global;
#define DATA_SIZE 4*262144
#define MEMORY_BLOCKS 64
/*__capability */volatile char shared_array_1[DATA_SIZE];
/*__capability */volatile char shared_array_2[DATA_SIZE];

void* hello(void* id)
{
	int i;
	if (*((int*)id) == 0)
	{ 
		//pthread_mutex_lock(&mutex_global);
		//printf("First thread begining to write memory. Time: %u\n", (unsigned)time(NULL));	
		printf("First thread begining to write memory\nTime: %lu\n", read_hw_counter());
		int j;
		for (j=0; j<MEMORY_BLOCKS; j++)	
		{
			for (i=0; i<DATA_SIZE/MEMORY_BLOCKS; i++)
			{
				shared_array_2[i + j*(DATA_SIZE/MEMORY_BLOCKS)] = shared_array_1[i + j*(DATA_SIZE/MEMORY_BLOCKS)]; 
			}
			global_counter++;
		}
		//printf("First thread ending\nTime: %lu\n", read_hw_counter());	
		//pthread_mutex_unlock(&mutex_global);
	}
	else
	{
		//printf("Second thread ready to read memory\nTime: %lu\n", read_hw_counter());
		int j;
		for (j=0; j<MEMORY_BLOCKS; j++)	
		{
			for (i=0; i<DATA_SIZE/MEMORY_BLOCKS; i++)
			{
				while(global_counter <= j);
				if (shared_array_2[i + j*(DATA_SIZE/MEMORY_BLOCKS)] != shared_array_1[i + j*(DATA_SIZE/MEMORY_BLOCKS)])
					printf("Memory Replication Error, shared_array_1[%d] = %d, shared_array_2[%d] = %d\n", i + j*(DATA_SIZE/MEMORY_BLOCKS),shared_array_1[i + j*(DATA_SIZE/MEMORY_BLOCKS)],i + j*(DATA_SIZE/MEMORY_BLOCKS),shared_array_2[i + j*(DATA_SIZE/MEMORY_BLOCKS)]);
				//printf("Shared_Array_2[%d]: %d\n", i, shared_array_2[i]);
				//else
				//	printf(".");
			}
		}
		printf("Second thread ending\nTime: %lu\n", read_hw_counter());
		
	}

	//while(1);
	//printf("%d: Global Counter = %d \n", *((int*) id), global_counter);
	return 0;
}

int main(int argc, char* argv[])
{
	const int COUNT = 2;
	int i, y;
	pthread_t thread[COUNT];
	int ids[COUNT];
	srand(12);

	for (i=0; i<DATA_SIZE; i++)
	{
		shared_array_1[i] = rand();
	}
	printf("\nRandom data gen has completed\n");

	for (i=0; i<COUNT; i++)
	{
		ids[i] = i;
		int retval = pthread_create(&thread[i], NULL, hello, &ids[i]);
		if (retval)
		{
			perror("Failed ptherad_create\n");
			return 1;
		}
	}

	//printf("Memory operation completed\nTime: %lu\n", read_hw_counter());
	//while(1);
	//for (i=0; i<100000000; i++);
	for (i=0; i<COUNT; i++) pthread_join(thread[i], NULL);
	//pthread_mutex_destroy(&mutex_global);
	//printf("Test completed successfully. Time: %u\n", (unsigned)time(NULL));
	printf("Test completed successfully\nTime: %lu\n", read_hw_counter());
	return 0;
}
