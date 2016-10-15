#include <sys/times.h>
#include <time.h>
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <semaphore.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/wait.h>

#include "aes256.c"

#if defined _X86_
	// X86
	#include "perfCountersX86.h"
#else
	// FOR MIPS
	#include "perfCounters.h"
	#include <inttypes.h>
	#include <err.h>
	#include <sys/param.h>
	#include <sys/cpuset.h>
#endif

// Standard Beri dL1 Size = 32x512 = 16384 bytes
// Standard Beri L2 Size = 32x2048 = 65536 bytes

char array_dcache[16384];
char array_l2[65536];

static volatile char null_value;

#define ARRAY_SIZE 16384

static int *signal_victim;
static int *signal_mem;
static double *time_capture;

struct attackPacket
{
	int time_type;
	int loop_limit;
	int increment;
	char *array;
};

void memory_burn(void *input)
{
	int i;
	volatile char local_store_value;

	struct attackPacket *packet = input;
	int time_type = packet->time_type;
	int loop_limit = packet->loop_limit;
	int increment = packet->increment;
	char *array = packet->array;

	struct timespec tstart={0,0}, tend={0,0};

	unsigned long t_start, t_end;

	// Write
	do {
		*signal_victim = 1;
	}
	while (*signal_mem < 1);

	//printf("Spy Write Begin\n");
	//fflush(stdout);

	for (i = 0; i < loop_limit; i = i + increment) {
		null_value = array[i];
		array[i] = '$';
		//printf("Mem Loop Write *array=%p \n", &array[i]);
		//fflush(stdout);
	}

	//printf("Spy Write End\n");
	//fflush(stdout);

	// Read
	do {
		*signal_victim = 2;
	}
	while (*signal_mem <= 2);
	//printf("MEM signal_victim(0): %d, signal_mem(0): %d\n", *signal_victim, *signal_mem);
	//fflush(stdout);

	//printf("Spy Read Begin\n");
	//fflush(stdout);

	// TIME START
	if (time_type == 0) {
		clock_gettime(CLOCK_MONOTONIC, &tstart);
	}
	else {
		t_start = mips_time_counter();
	}

	for (i = 0; i < loop_limit; i = i + increment) {
		// TEST
		//null_value = array[i];
		local_store_value = array[i];
		//printf("Avg Read Time [%d]: %.16f \n", i, read_time);
		//fflush(stdout);
	}

	// TIME END & SAVE
	if (time_type == 0) {
		clock_gettime(CLOCK_MONOTONIC, &tend);
		*time_capture = ((double)tend.tv_sec + 1.0e-9*tend.tv_nsec) - ((double)tstart.tv_sec + 1.0e-9*tstart.tv_nsec);
	}
	else {
		t_end = mips_time_counter();
		*time_capture = (double) t_end - (double) t_start;
	}

	//printf("Spy Read End\n");
	//fflush(stdout);

	free(input);
}

/*
void victim_function(int key_value, int dummy_test, char *array)
{
	int i;

	do {
		*signal_mem = 1;
	}
	while (*signal_victim == 0);
	
	do {
		*signal_mem = 2;
	}
	while (*signal_victim < 2);
	//printf("VICTIM signal_victim(0): %d, signal_mem(0): %d\n", *signal_victim, *signal_mem);
	//fflush(stdout);
	
	//printf("Victim Loop Begin\n");
	//fflush(stdout);

        if (dummy_test == 0) {
                // RUN VICTIM TEST WITH FULL MEMORY OPERATIONS
                for (i = 0; i < key_value; i++) {
                        null_value = array[i];
                        array[i] = '@';
                        //printf("VictimArray[%d]: %c, %c\n", i, tmp_value, array[i]);
                        //fflush(stdout);
			//printf("Victim *array=%p \n", &array[i]);
                        //fflush(stdout);
                }
        }

	//printf("Victim Loop End\n");
	//fflush(stdout);

	do {
		*signal_mem = 3;
	}
	while (*signal_victim < 3);
	//printf("VICTIM signal_victim(1): %d, signal_mem(1): %d\n", *signal_victim, *signal_mem);
	//fflush(stdout);
}
*/

int main(int argc, char *argv[])
{
	//printf("Default options: -t0{use clock time} -i0{DCache array size} -h0{hop 32 char's} -d?{default loop_limit = array_size}\n");
	//fflush(stdout);

	int c;
	extern char *optarg;
	int test_number = 0;
	int test_depth = 0;
	int time_type = 0;
	int hop_options = 0;
	int key_value = 0;
	int dummy_test = 0;
	int loop_limit = ARRAY_SIZE;

	char *array;
	int increment;

	signal_victim = mmap(NULL, sizeof *signal_victim, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
	signal_mem = mmap(NULL, sizeof *signal_mem, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
	time_capture = mmap(NULL, sizeof *time_capture, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
	*signal_victim = 0;
	*signal_mem = 0;
	*time_capture = 0;
	//printf("main signal_victim(0): %d, signal_mem(0): %d\n", *signal_victim, *signal_mem);
	//fflush(stdout);

	while ((c = getopt(argc, argv, "j:t:i:h:k:d:stoh")) != -1) {
		switch (c) {
			case 'j': test_number = atoi(optarg);
				break;
			case 't': time_type = atoi(optarg);
				break;
			case 'i': test_depth = atoi(optarg);
				break;
			case 'h': hop_options = atoi(optarg);
				break;
			case 'k': key_value = atoi(optarg);
				break;
			case 'd': dummy_test = atoi(optarg);
				break;
			default: test_number = 0;  
				time_type = 0;
				test_depth = 0;
				hop_options = 0;
				key_value = ARRAY_SIZE;
				dummy_test = 0;
				break;
		}
	}

	switch (test_depth) {
		case 0: array = array_dcache;
			loop_limit = sizeof(array_dcache)/sizeof(array_dcache[0]);
			break;
		case 1: array = array_l2;
			loop_limit = sizeof(array_l2)/sizeof(array_l2[0]);
			break;
		default: array = array_dcache;
			loop_limit = sizeof(array_dcache)/sizeof(array_dcache[0]);
			break;
	}
	
	switch (hop_options) {
		case 0: increment = 32; 
			break;
		case 1: increment = 1;
			break;
		default: increment = 1;
			break;
	}

	//printf("main pre-fork  signal_victim(1): %d, signal_mem(1): %d\n", *signal_victim, *signal_mem);
	//fflush(stdout);

	int k = 0;
	for (k = 0; k <= test_number; k++) {
		*signal_victim = 0;
		*signal_mem = 0;
		*time_capture = 0;

		pid_t pid;
		pid = fork();
		if (pid == 0) {
			struct attackPacket *packet;
			packet = malloc(sizeof(*packet));
			packet->time_type = time_type;
			packet->loop_limit = loop_limit;
			packet->increment = increment;
			packet->array = array;

			//printf("PID_0 pre-test signal_victim(0): %d, signal_mem(0): %d\n", *signal_victim, *signal_mem);
			//fflush(stdout);

			//printf("Begin Spy Test\n");
			//fflush(stdout);

			// !!! BEGIN CORE PIN >>
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

			// Set new CPU mask 
			//printf ("Setting affinity to CPU %d\n", i);
			CPU_ZERO(&myset);
			CPU_SET(i, &myset);

			if (cpuset_setaffinity(CPU_LEVEL_WHICH, CPU_WHICH_TID, -1, sizeof(myset), &myset) == -1){
				warn("setaffinity failed");
			}
		
			// Begin Test
			memory_burn(packet);
			// End Test

			if (cpuset_getaffinity(CPU_LEVEL_WHICH, CPU_WHICH_TID, -1, sizeof(myset), &myset) == -1){
				err(1, "getaffinity failed");
			}

			if (cpuset_setaffinity(CPU_LEVEL_WHICH, CPU_WHICH_TID, -1, sizeof(newset), &newset) == -1){
				warn("setaffinity failed");
			}
			// !!! END CORE PIN <<
		
			//printf("End Spy Test\n");
			//fflush(stdout);

			if (time_type == 0) {
				printf("%.6f\n", (*time_capture)*1000000);
				fflush(stdout);
			}
			else {
				// MIPS COUNTER IS AN INT, ALWAYS GREATER THAN 1
				printf("%.6f\n", *time_capture);
				fflush(stdout);
			}
	
			do {
				*signal_victim = 3;
			}
			while (*signal_mem < 3);
			//printf("PID_0 post-test signal_victim(1): %d, signal_mem(1): %d\n", *signal_victim, *signal_mem);
			//fflush(stdout);

			exit(2);
		}
		else {
			//printf("PID_1 pre-test signal_victim(0): %d, signal_mem(0): %d\n", *signal_victim, *signal_mem);
			//fflush(stdout);

// CREATE VICTIM DATA & VAR'S >>
			aes256_context ctx; 
			uint8_t key[32];
			uint8_t buf[16];
			uint8_t j;
// CREATE VICTIM DATA & VAR'S <<

			//printf("Begin Victim Test\n");
			//fflush(stdout);

			// !!! BEGIN CORE PIN >>
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
		
// BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN

// CREATE UNIQUE AES 256 KEY >>
			for (j = 0; j < sizeof(key); j++) {
				if (key_value == 0) {
					key[j] = 0;		// Create NULL key
				}
				else {
					key[j] = j;		// Create unique key
				}
			}
// CREATE UNIQUE AES 256 KEY >>

// FILL TEXT TO ENCRYPT >>
			for (j = 0; j < sizeof(buf)/sizeof(buf[0]); j++) {
				null_value = buf[j]; 	// Pull init values into cache
				buf[j] = j;		// Populate cached data with var's
			}
// FILL TEXT TO ENCRYPT <<

// SYNC WITH SPY >>
			do {
				*signal_mem = 1;
			}
			while (*signal_victim == 0);
			
			do {
				*signal_mem = 2;
			}
			while (*signal_victim < 2);
			//printf("AES signal_victim(0): %d, signal_mem(0): %d\n", *signal_victim, *signal_mem);
			//fflush(stdout);
			
			//printf("AES Loop Begin\n");
			//fflush(stdout);
// SYNC WITH SPY <<

// INIT AES >>
			aes256_init(&ctx, key);
// INIT AES <<

// RUN ENCRYPTION >>
			aes256_encrypt_ecb(&ctx, buf);
// RUN ENCRYPTION <<

// CLEANUP AES >> 
			aes256_done(&ctx);
// CLEANUP AES << 

// SYNC COMPLETION WITH SPY >> 
			//printf("AES Loop End\n");
			//fflush(stdout);

			do {
				*signal_mem = 3;
			}
			while (*signal_victim < 3);
			//printf("AES signal_victim(1): %d, signal_mem(1): %d\n", *signal_victim, *signal_mem);
			//fflush(stdout);
// SYNC COMPLETION WITH SPY << 

// END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END 		

			if (cpuset_getaffinity(CPU_LEVEL_WHICH, CPU_WHICH_TID, -1, sizeof(myset), &myset) == -1){
				err(1, "getaffinity failed");
			}

			if (cpuset_setaffinity(CPU_LEVEL_WHICH, CPU_WHICH_TID, -1, sizeof(newset), &newset) == -1){
				warn("setaffinity failed");
			}
			// !!! END CORE PIN <<

			//printf("End Victim Test\n");
			//fflush(stdout);

			*signal_mem = 4;

			//printf("PID_1 post-test signal_victim(1): %d, signal_mem(1): %d\n", *signal_victim, *signal_mem);
			//fflush(stdout);
			exit(2);
		}
	}
		
	return 0;
}


