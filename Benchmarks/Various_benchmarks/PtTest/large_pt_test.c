#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
//#include<math.h>
//#include<time.h>
#include"rdhwr.c"

//volatile int global_counter = 0;
//volatile int shared_array_1[5] = {1,2,3,4,5};
//volatile int shared_array_2[5] = {0,0,0,0,0};
//pthread_mutex_t mutex_global;
#define DATA_SIZE 20//262144
//volatile int shared_array_1[DATA_SIZE];
//volatile int shared_array_2[DATA_SIZE];
/*
void* hello(void* id)
{
	int i;
	if (*((int*)id) == 0)
	{ 
		//pthread_mutex_lock(&mutex_global);
		//printf("First thread begining to write memory. Time: %u\n", (unsigned)time(NULL));	
		printf("First thread begining to write memory\nTime: %lu\n", read_hw_counter());	

		for (i=0; i<DATA_SIZE; i++)
		{
			shared_array_1[i] = rand();
			shared_array_2[i] = shared_array_1[i]; 
			global_counter++;
		}
		//pthread_mutex_unlock(&mutex_global);
	}
	else
	{
		printf("Second thread ready to read memory\nTime: %lu\n", read_hw_counter());
		for (i=0; i<DATA_SIZE; i++)
		{
			//while(global_counter <= i);
			//if (shared_array_2[i] != shared_array_1[i])
			//	printf("Memory Replication Error\n");
			//else
			//	printf(".");
			static int j = 0;
			j++;
		}
		
	}

	//printf("%d: Global Counter = %d \n", *((int*) id), global_counter);
	return 0;
}
*/

void* thread_1(void* array)
{
	int* local_array = (int*) array;
	int i=0;
	printf("Starting thread 1\nTime: %lu\n", read_hw_counter());
	for (i=0; i<DATA_SIZE/2; i++)
	{
		local_array[i] = rand();
		printf("Thread 1 Data[%d]:%d, Time: %lu\n", i, local_array[i], read_hw_counter());
	}
	printf("Ending thread 1\nTime: %lu\n", read_hw_counter());
	return 0;
}

void* thread_2(void* array)
{
	int* local_array = (int*) array;
	int i=0;
	printf("Starting thread 2\nTime: %lu\n", read_hw_counter());
	for (i=DATA_SIZE/2; i<DATA_SIZE; i++)
	{
		//local_array[i] = rand();
		printf("Thread 2 Data[%d]:%d, Time: %lu\n", i, local_array[i], read_hw_counter());
	}
	printf("Ending thread 2\nTime: %lu\n", read_hw_counter());
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

	int retval = pthread_create(&thread[0], NULL, thread_1, &array);
	if (retval)
	{
		perror("Failed ptherad_create\n");
		return 1;
	}
	retval = pthread_create(&thread[1], NULL, thread_2, &array);
	if (retval)
	{
		perror("Failed ptherad_create\n");
		return 1;
	}

/*
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
*/
	printf("Memory operation completed\nTime: %lu\n", read_hw_counter());
	for (i=0; i<100000000; i++);
	//for (i=0; i<COUNT; i++) pthread_join(thread[i], NULL);
	//pthread_mutex_destroy(&mutex_global);
	//printf("Test completed successfully. Time: %u\n", (unsigned)time(NULL));
	printf("Test completed successfully\nTime: %lu\n", read_hw_counter());
	return 0;
}
