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

#if defined _X86_
	// X86
	#include "perfCountersX86.h"
#else
	// FOR MIPS
	#include "perfCounters.h"
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
	int read = 0;
	volatile char local_store_value;

	struct attackPacket *packet = input;
	int time_type = packet->time_type;
	int loop_limit = packet->loop_limit;
	int increment = packet->increment;
	char *array = packet->array;

	struct timespec tstart={0,0}, tend={0,0};

	unsigned long t_start, t_end;

	while(1) {
		// Write
		if (read == 0) {
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
			read = 1;

			//printf("Spy Write End\n");
			//fflush(stdout);
		}
		// Read
		else {
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

			read = 0;
			break;
		}
	}
	free(input);
}

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
	int key_value = ARRAY_SIZE;
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

			memory_burn(packet);
		
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

			char *victim_array;
			victim_array = (char *)malloc(sizeof(char)*ARRAY_SIZE);

			//printf("Begin Victim Test\n");
			//fflush(stdout);

			victim_function(key_value, dummy_test, victim_array);
		
			//printf("End Victim Test\n");
			//fflush(stdout);

			free(victim_array);

			*signal_mem = 4;
			//printf("PID_1 post-test signal_victim(1): %d, signal_mem(1): %d\n", *signal_victim, *signal_mem);
			//fflush(stdout);
		}
	}
		
	return 0;
}


