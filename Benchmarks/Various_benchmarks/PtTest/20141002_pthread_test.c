#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
//#include"rdhwr.c"

volatile int global_counter = 0;
#define DATA_SIZE 100
volatile char shared_array_1[DATA_SIZE];
volatile char shared_array_2[DATA_SIZE];

void* sharing_test(void* id)
{
	int i;
	if (*((int*)id) == 0)
	{ 
		//printf("First thread begining to write memory\nTime: %lu\n", read_hw_counter());
		//printf("First thread begining to write memory\nTime: %d\n", 0);
		int j;
		for (j=0; j<4; j++)	
		{
			for (i=0; i<DATA_SIZE/4; i++)
			{
				shared_array_2[i + j*(DATA_SIZE/4)] = shared_array_1[i + j*(DATA_SIZE/4)]; 
			}
			global_counter++;
		}
	}
	else
	{
		int j;
		for (j=0; j<4; j++)	
		{
			for (i=0; i<DATA_SIZE/4; i++)
			{
				while(global_counter <= j);
				if (shared_array_2[i + j*(DATA_SIZE/4)] != shared_array_1[i + j*(DATA_SIZE/4)])
					printf("Memory Replication Error, shared_array_1[%d] = %d, shared_array_2[%d] = %d\n", i + j*(DATA_SIZE/4),shared_array_1[i + j*(DATA_SIZE/4)],i + j*(DATA_SIZE/4),shared_array_2[i + j*(DATA_SIZE/4)]);
			}
		}
		//printf("Second thread ending\nTime: %lu\n", read_hw_counter());
		//printf("Second thread ending\nTime: %d\n", 1);
		
	}

	return 0;
}

int main(int argc, char* argv[])
{
	const int COUNT = 2;
	int i, y;
	pthread_t thread[COUNT];
	int ids[COUNT];
	int array[DATA_SIZE] = {0};
	srand(12);

	for (i=0; i<DATA_SIZE; i++)
	{
		shared_array_1[i] = rand();
	}

	for (i=0; i<COUNT; i++)
	{
		ids[i] = i;
		int retval = pthread_create(&thread[i], NULL, sharing_test, &ids[i]);
		if (retval)
		{
			perror("Failed ptherad_create\n");
			return 1;
		}
	}

	for (i=0; i<COUNT; i++) pthread_join(thread[i], NULL);

	//printf("Test completed successfully\nTime: %d\n", 2);
	return 0;
	printf("Test completed successfully\nTime: %d\n", 2);
}
