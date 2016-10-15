#include "perfCounters.h"

static inline void * print_counters(unsigned long long *output)
{

	int i;
	cpuset_t myset;
	cpuset_t newset;

	// Get CPU mask for the current thread 
	if (cpuset_getaffinity(CPU_LEVEL_WHICH, CPU_WHICH_TID, -1, sizeof(myset), &myset) == -1){
		err(1, "getaffinity failed");
	}
	
	newset = myset;

	// Find first available CPU - don't assume CPU0 is always available 
	for (i = 0; i < CPU_SETSIZE; i++){
		if (CPU_ISSET(i, &myset)){
			//printf("\nCPU_ISSET myset: %d", i);
			break; 
		}
	}

	if (i == CPU_SETSIZE){
		err(1, "Not allowed to run on any CPUs?  How did I print this, then?");
	}

	// Set new CPU mask 
	//printf ("Setting affinity to CPU %d\n", i);
	CPU_ZERO(&myset);
	CPU_SET(i, &myset);

	if (cpuset_setaffinity(CPU_LEVEL_WHICH, CPU_WHICH_TID, -1, sizeof(myset), &myset) == -1){
		warn("setaffinity failed");
	}

	//printf("*** Performance Counters ***\n\tMiss:%llu\n\tHit:%llu\n\t?LL|SYNC:%llu\n\t?SC|INIT:%llu\n\t?Inv|TimeMiss:%llu\n\t?InvHit|TimeHit:%llu\n", (unsigned long long) read_miss_counter(), (unsigned long long) read_hit_counter(), (unsigned long long) read_sync_counter(), (unsigned long long) read_init_counter(), (unsigned long long) read_timeMiss_counter(), (unsigned long long) read_timeHit_counter());

	unsigned long long tmp_output[7];

	tmp_output[0] = (unsigned long long) i;
	tmp_output[1] = (unsigned long long) read_miss_counter();
	tmp_output[2] = (unsigned long long) read_hit_counter();
	tmp_output[3] = (unsigned long long) read_sync_counter();
	tmp_output[4] = (unsigned long long) read_init_counter();
	tmp_output[5] = (unsigned long long) read_timeMiss_counter();
	tmp_output[6] = (unsigned long long) read_timeHit_counter();

	//printf("*** Performance Counters ***\n\tMiss:%llu\n\tHit:%llu\n\t?LL|SYNC:%llu\n\t?SC|INIT:%llu\n\t?Inv|TimeMiss:%llu\n\t?InvHit|TimeHit:%llu\n", tmp_output[1], tmp_output[2], tmp_output[3], tmp_output[4], tmp_output[5], tmp_output[6]);

	int j;
	for (j = 0; j < 7; j++)
	{
		output[j] = tmp_output[j];
	}

	if (cpuset_getaffinity(CPU_LEVEL_WHICH, CPU_WHICH_TID, -1, sizeof(myset), &myset) == -1){
		err(1, "getaffinity failed");
	}

	if (cpuset_setaffinity(CPU_LEVEL_WHICH, CPU_WHICH_TID, -1, sizeof(newset), &newset) == -1){
		warn("setaffinity failed");
	}

}

