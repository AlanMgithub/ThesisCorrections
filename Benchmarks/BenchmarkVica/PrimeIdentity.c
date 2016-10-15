/*
	PRIME IDENTITY

	This program identifies all primes from 2 -> Input Array
	Highly parallelisable 
*/

// ***********************
// GLOBAL VARIABLES
// ***********************
struct timeval  time_begin_main,
                time_end_main,
                time_1_begin,
                time_1_end,
                time_2_begin,
                time_2_end,
                time_3_begin,
                time_3_end,
                time_4_begin,
                time_4_end
;

volatile int PROC_COUNT;
volatile int INPUT_SIZE;

// ***********************
// FUNCTIONS 
// ***********************
void *checker(void *param) {
	int i = *((int *) param);
	int j;
	int trap = 0;
	//printf("{%d} ", i);

	/* Check each number for divisibility */
	for(j = 2; j < i; j++) {
		int result = i % j;
		if(result == 0) {
			trap = 1;
			break;
		}
	}
	//No numbers divided cleanly so this number must be prime
	if(trap == 0) {
		//printf("[%d] ", i);
	}
	pthread_exit(0);
}

volatile int prevent_optimisation;
static volatile void *checker_one(void *param) {
	int i = *((int *) param);
	int j;
	int trap = 0;
	//printf("{%d} ", i);

	/* Check each number for divisibility */
	for(j = 2; j < i; j++) {
		int result = i % j;
		if(result == 0) {
			trap = 1;
			break;
		}
		if (result < 0) {
			prevent_optimisation++;
		}
	}
	//No numbers divided cleanly so this number must be prime
	if(trap == 0) {
		//printf("[%d] ", i);
	}
}

void *prime_function() {
	int i,j,k;
	int chunk;
	int prime_candidates[PROC_COUNT];

        // ***********************
        // Performance Counters
        unsigned long long perfMainBegin[7];
        unsigned long long perfMainEnd[7];
        unsigned long long perfBegin1[7];
        unsigned long long perfEnd1[7];
        unsigned long long perfBegin2[7];
        unsigned long long perfEnd2[7];
        unsigned long long perfBegin3[7];
        unsigned long long perfEnd3[7];
        unsigned long long perfBegin4[7];
        unsigned long long perfEnd4[7];

        // +++++++++++++++++++++++ 
        // CREATE PTHREAD AND INIT
	pthread_t tid[PROC_COUNT];       
 
	//printf("Input Upper: %d\n", INPUT_SIZE);

	// ***********************
        // ALGORITHM BEGIN
        // ***********************
        gettimeofday(&time_begin_main, NULL); // GET TIME
        print_counters(perfMainBegin);

	// SINGLE THREAD RUN
        gettimeofday(&time_1_begin, NULL); // GET TIME
        print_counters(perfBegin1);

	chunk = INPUT_SIZE;
	int one_thread = 1;
	pthread_t one_tid;
	for(k = 0; k < chunk; k++) {
		for(i = 0; i < one_thread; i++) {
			prime_candidates[i] = (one_thread*k)+i+2;
			//printf("{%d,%d}",prime_candidates[i], &prime_candidates[i]);
			pthread_create(&tid[i],NULL,checker, &prime_candidates[i]);
		}
		for(i = 0; i < one_thread; i++) {
			pthread_join(tid[i],NULL);
		}
	}

        print_counters(perfEnd1);
        gettimeofday(&time_1_end, NULL); // GET TIME

	// MULTI-THREAD RUN
        gettimeofday(&time_2_begin, NULL); // GET TIME
        print_counters(perfBegin2);

	chunk = INPUT_SIZE/PROC_COUNT;
	for(k = 0; k < chunk; k++) {
		for(i = 0; i < PROC_COUNT; i++) {
			prime_candidates[i] = (PROC_COUNT*k)+i+2;
			//printf("{%d,%d}",prime_candidates[i], &prime_candidates[i]);
			pthread_create(&tid[i],NULL,checker, &prime_candidates[i]);
		}
		for(i = 0; i < PROC_COUNT; i++) {
			pthread_join(tid[i],NULL);
		}
	}

        print_counters(perfEnd2);
        gettimeofday(&time_2_end, NULL); // GET TIME

	// SINGLE FUNCTION RUN
        gettimeofday(&time_3_begin, NULL); // GET TIME
        print_counters(perfBegin3);

	chunk = INPUT_SIZE;
	for(k = 0; k < chunk; k++) {
		int prime_candidate = k+2;
		checker_one(&prime_candidate);
	}

        print_counters(perfEnd3);
        gettimeofday(&time_3_end, NULL); // GET TIME


        print_counters(perfMainEnd);
        gettimeofday(&time_end_main, NULL);

        double total_time = (double)(time_end_main.tv_usec - time_begin_main.tv_usec)/1000000
                          + (double)(time_end_main.tv_sec - time_begin_main.tv_sec);
        double single_t_time = (double)(time_1_end.tv_usec - time_1_begin.tv_usec)/1000000
                           + (double)(time_1_end.tv_sec - time_1_begin.tv_sec);
        double multi_t_time = (double)(time_2_end.tv_usec - time_2_begin.tv_usec)/1000000
                         + (double)(time_2_end.tv_sec - time_2_begin.tv_sec);
	double one_function_time = (double)(time_3_end.tv_usec - time_3_begin.tv_usec)/1000000
                         + (double)(time_3_end.tv_sec - time_3_begin.tv_sec);
	double speed_up_nm = (one_function_time)/(multi_t_time);
	double speed_up_sm = (single_t_time)/(multi_t_time);

        total_time = total_time*1000000;
        single_t_time = single_t_time*1000000;
        one_function_time = one_function_time*1000000;
        multi_t_time = multi_t_time*1000000;

        // PRINT RESULTS
        printf("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++");
        printf("\n\t* TIMING STATS\n");
        printf("\t\tTOTAL          :  %.0f\n", total_time);
        printf("\t\tSINGLE (N)     :  %.0f (no threads)\n", one_function_time);
        printf("\t\tSINGLE (S)     :  %.0f (pthread)\n", single_t_time);
        printf("\t\tMULTI  (M)     :  %.0f (pthreads)\n", multi_t_time);
        printf("\n\t* PERFORMANCE STATS\n");
        printf("\t\tSPEED UP (N/M) :  %f\n", speed_up_nm);
        printf("\t\tSPEED UP (S/M) :  %f\n", speed_up_sm);
        printf("\n\t* PERFORMANCE COUNTERS\n");
        for (i = 0; i < 7; i++){
                if (i==0){
                        printf("\t\tTOTAL      :  %llu", perfMainBegin[0]);
                }
                else {
                        printf(":%llu", perfMainEnd[i]-perfMainBegin[i]);

                }
        }
        for (i = 0; i < 7; i++){
                if (i==0){
                        printf("\n\t\tSINGLE (N) :  %llu", perfBegin3[0]);
                }
                else {
                        printf(":%llu", perfEnd3[i]-perfBegin3[i]);

                }
        }
        for (i = 0; i < 7; i++){
                if (i==0){
                        printf("\n\t\tSINGLE (S) :  %llu", perfBegin1[0]);
                }
                else {
                        printf(":%llu", perfEnd1[i]-perfBegin1[i]);

                }
        }
        for (i = 0; i < 7; i++){
                if (i==0){
                        printf("\n\t\tMULTI  (M) :  %llu", perfBegin2[0]);
                }
                else {
                        printf(":%llu", perfEnd2[i]-perfBegin2[i]);
                }
        }
        printf("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
        printf("\n");

}

// ***********************
// MAIN
// ***********************
int prime_identity(int no_of_processors, int input_size) {
	PROC_COUNT = no_of_processors;
	INPUT_SIZE = input_size;
	prime_function();
	pthread_exit(0);
}

