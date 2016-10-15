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

int main(int argc, char *argv[])
{
	//printf("Default options: -t0{use clock time} -i0{DCache array size} -h0{hop 32 char's} -d?{default loop_limit = array_size}\n");
	//fflush(stdout);

	int c;
	extern char *optarg;
	int test_type = 0;
	int time_type = 0;
	int hop_options = 0;
	int key_value = ARRAY_SIZE;
	int dummy_test = 0;
	int loop_limit = ARRAY_SIZE;

	char *array;
	int increment;

	char test_value = 'a';

        struct timespec tstart={0,0}, tend={0,0};
        unsigned long t_start, t_end;


	while ((c = getopt(argc, argv, "t:i:h:d:m:stoh")) != -1) {
		switch (c) {
			case 't': time_type = atoi(optarg);
				break;
			case 'i': test_type = atoi(optarg);
				break;
			case 'h': hop_options = atoi(optarg);
				break;
			case 'd': key_value = atoi(optarg);
				break;
			case 'm': dummy_test = atoi(optarg);
				break;
			default: time_type = 0;
				test_type = 0;
				hop_options = 0;
				key_value = ARRAY_SIZE;
				dummy_test = 0;
				break;
		}
	}

	switch (test_type) {
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

	double *time_capture;
	time_capture = malloc(loop_limit/increment * sizeof(double));
	if (time_capture == NULL)
	{
	        printf("Failed to allocate memory, time_capture = malloc(loop_limit * sizeof(double));");
                return 1;
	}

	char *victim_array;
	victim_array = (char *)malloc(sizeof(char)*ARRAY_SIZE);
	if (victim_array == NULL)
	{
	        printf("Failed to allocate memory, victim_array = (char *)malloc(sizeof(char)*ARRAY_SIZE);");
                return 1;
	}

        // *** Write Spy Data
	int i;
	for (i = 0; i < loop_limit; i = i + increment) {
		array[i] = test_value + (char)i;
	}

	// *** Victim Code Runs
	volatile char tmp_value;	
        if (dummy_test == 0) {
                for (i = 0; i < key_value; i++) {
                        tmp_value = victim_array[i];
                        tmp_value = tmp_value + '@';
                        victim_array[i] = tmp_value;
                        //printf("VictimArray[%d]: %c, %c\n", i, tmp_value, victim_array[i]);
                        //fflush(stdout);
			//printf("Victim *victim_array=%p \n", &victim_array[i]);
                        //fflush(stdout);
                }
        }

	// *** Read Spy Data and Time Latency
	int k = 0;
	for (i = 0; i < loop_limit; i = i + increment) {
		/*
		if (time_type == 0) {
			clock_gettime(CLOCK_MONOTONIC, &tstart);
		}
		else {
			t_start = read_miss_counter();
		}
		*/

		// Timing Test
		clock_gettime(CLOCK_MONOTONIC, &tstart);
		null_value = array[i];
		clock_gettime(CLOCK_MONOTONIC, &tend);
		time_capture[k] = ((double)tend.tv_sec + 1.0e-9*tend.tv_nsec) - ((double)tstart.tv_sec + 1.0e-9*tstart.tv_nsec);
	
/*
		if (time_type == 0) {
			clock_gettime(CLOCK_MONOTONIC, &tend);
			time_capture[k] = ((double)tend.tv_sec + 1.0e-9*tend.tv_nsec) - ((double)tstart.tv_sec + 1.0e-9*tstart.tv_nsec);
		}
		else {
			t_end = read_miss_counter();
			time_capture[k] = (double) t_end - (double) t_start;
		}
*/		
		k++;
	}

	// *** Print Side Channel Attack Timings
	for (i = 0; i < loop_limit/increment; i++) {
		printf("%.6f\n", time_capture[i]*1000000);
		fflush(stdout);
	}

	free(time_capture);
	free(victim_array);

	return 0;
}


