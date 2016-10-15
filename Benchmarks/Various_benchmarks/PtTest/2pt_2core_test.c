#include<pthread.h>
#include<stdio.h>
#include<stdlib.h>
#include<sched.h>
#include<math.h>
#include<string.h>
#include<sched.h>

volatile int global_counter = 0;
volatile int shared_array_1[5] = {1,2,3,4,5};
volatile int shared_array_2[5] = {0,0,0,0,0};
//pthread_mutex_t mutex_global;
#define DATA_SIZE (int) pow((double) 2, 18)

void* hello(void* id)
{
	printf("Core ID:: %d\n", sched_getcpu());
	int i;
	if (*((int*)id) == 0)
	{ 
		//pthread_mutex_lock(&mutex_global);	
		for (i=0; i<5; i++)
		{
			shared_array_2[i] = shared_array_1[i] + 1*i; 
			global_counter++;
			printf("%d: Shared Array 1 [%d] = %d \n", *((int*) id), i, shared_array_1[i]);
		}
		//pthread_mutex_unlock(&mutex_global);
	}
	else
	{
		for (i=0; i<5; i++)
		{
			//pthread_mutex_lock(&mutex_global);	
			while(global_counter <= i);
			//pthread_mutex_unlock(&mutex_global);
			printf("%d: Shared Array 2 [%d] = %d \n", *((int*) id), i, shared_array_2[i]);
		}
		
	}
	printf("Core ID:: %d\n", sched_getcpu());
	return 0;
}

int main(int argc, char* argv[])
{
	const int COUNT = 2;
	int i, y;
	pthread_t thread[COUNT];
	int ids[COUNT];
	cpu_set_t cpuset[COUNT];

	for (i=0; i<COUNT; i++)
	{
		int retval = pthread_create(&thread[i], NULL, hello, &ids[i]);
		if (retval)
		{
			perror("ptherad_created failed");
			return 1;
		}
	}

	for (i=0; i<COUNT; i++)
	{
		ids[i] = i;
		CPU_ZERO(&cpuset[i]);
		CPU_SET(0, &cpuset[i]);
		int retval = pthread_setaffinity_np(thread[i], sizeof(cpu_set_t), &cpuset[i]);
		if (retval)
		{
			printf("error %d\n", retval);
			perror("pthread_setaffinity_np failed\n");
			printf("ERROR:: %s\n", strerror(retval));
			return 1;
		}
	}

	for (i=0; i<COUNT; i++) pthread_join(thread[i], NULL);
	//pthread_mutex_destroy(&mutex_global);
	return 0;
}
