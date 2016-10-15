/*
	BLOCK SELECTION SORT	

	Sorts an array of elements in asending order
*/

// ***********************
// GLOBAL VARIABLES
// ***********************
struct selectionSortParamiters
{
	int low_pointer;
	int high_pointer;
	int *input_array;
};

struct timeval 	time_begin_main, 
		time_end_main,
		time_scan_verify_begin,
		time_scan_verify_end,
		time_scan_run_begin,
		time_scan_run_end
;

// ***********************
// FUNCTIONS 
// ***********************
void * selection_sort(void *input)
{
	int i, j, pin;
	struct selectionSortParamiters *var = input;
	int low_pointer = var->low_pointer;
	int high_pointer = var->high_pointer;
	int *sort_array = var->input_array;

	for (j = low_pointer; j < high_pointer; j++)
	{
		pin = j;
		for (i = j+1; i < high_pointer; i++)
		{
			if (sort_array[i] < sort_array[pin])
			{
				pin = i;
			}
		}

		if (pin != j)
		{
			int tmp = sort_array[j];
			sort_array[j] = sort_array[pin];
			sort_array[pin] = tmp;
		}
	}

	return sort_array;
}
// ***********************
// MAIN
// ***********************
int block_selection_sort_test(int no_of_processors, int array_length)
{
	int i;
        // ***********************
        // Performance Counters
        unsigned long long perfMainBegin[7];
        unsigned long long perfMainEnd[7];
        unsigned long long perfBegin1[7];
        unsigned long long perfEnd1[7];
        unsigned long long perfBegin2[7];
        unsigned long long perfEnd2[7];

	// +++++++++++++++++++++++ 
	// CREATE PTHREAD AND INIT
	pthread_t thread[no_of_processors];
	pthread_attr_t attribute;
	int pthread_rc;
	long pthread_t;
	void *pthread_status;

	pthread_attr_init(&attribute);
	pthread_attr_setdetachstate(&attribute, PTHREAD_CREATE_JOINABLE);
	// +++++++++++++++++++++++ 

	// ***********************
	// ALGORITHM BEGIN
	// ***********************
	gettimeofday(&time_begin_main, NULL); // GET TIME
	print_counters(perfMainBegin);

	// GENERATE RANDOM ARRAY
	int *sort_array;
	sort_array = malloc((array_length) * sizeof(int));
	if (sort_array == NULL)
	{
		printerr("Failed to allocate memory, sort_array = malloc(array_length * sizeof(int));");
		return 1;
	}
	
	random_array_generator(array_length, sort_array);

	int low_pointer = 0;
	int high_pointer = array_length - 1;

	// DEFAULT CHECK FOR CORRECTNESS WITH A SINGLE INSTANCE RUN
	int *verify_array;
	verify_array = malloc(array_length * sizeof(int));
	if (verify_array == NULL)
	{
		printerr("Failed to allocate memory, verify_array = malloc(array_length * sizeof(int));");
		return 1;
	}

	for (i = 0; i <= high_pointer; i++)
	{
		verify_array[i] = sort_array[i];
	}

	gettimeofday(&time_scan_verify_begin, NULL); // GET TIME
	print_counters(perfBegin1);

	struct selectionSortParamiters *verify;
	verify = malloc(sizeof(*verify));
	verify->low_pointer = low_pointer;
	verify->high_pointer = high_pointer;
	verify->input_array = verify_array;

	// CREATE VERIFY ARRAY
	selection_sort(verify);

	print_counters(perfEnd1);
	gettimeofday(&time_scan_verify_end, NULL); // GET TIME

	free(verify);
/*	
	for (i = 0; i < array_length; i++)
	{
		printf("Verify Array[%d]: %d\n", i, verify_array[i]);
	}
	printf("\n");
*/

	// MULTICORE RUN OF THE ALGORITHM
	gettimeofday(&time_scan_run_begin, NULL); // GET TIME
	print_counters(perfBegin2);

	// WITH P-THREADS
	int proc_no;// = no_of_processors;
	//while (proc_no > 0)
	for (proc_no = no_of_processors; proc_no > 0; proc_no--)
	{
// !!! WARNING - This step is only for enhancing parallelism and not correctness !!! >>
		int tmp_proc_val = no_of_processors;		
		//for (i = 0; i < proc_no; i++)
		for (i = 0; i < tmp_proc_val; i++)
// !!! WARNING - This step is only for enhancing parallelism and not correctness !!! <<
                {
			// BUILD STRUCT
			struct selectionSortParamiters *single_t;
			single_t = malloc(sizeof(*single_t));
			single_t->input_array = sort_array;
// !!! WARNING - This step is only for enhancing parallelism and not correctness !!! >>
			//int chunk = array_length/proc_no;
			int chunk = array_length/tmp_proc_val;
// !!! WARNING - This step is only for enhancing parallelism and not correctness !!! <<
			single_t->low_pointer = i*chunk;
			single_t->high_pointer = (i + 1)*chunk;
			// ENSURE TOP INDEX ARRAY ELEMENTS ARE CALCULATED
// !!! WARNING - This step is only for enhancing parallelism and not correctness !!! >>
	                //if (i == proc_no-1)
	                if (i == tmp_proc_val-1)
// !!! WARNING - This step is only for enhancing parallelism and not correctness !!! <<
			{
				single_t->high_pointer = array_length - 1;
			}
			//printf("Pointer low: %d, high: %d\n", single_t->low_pointer, single_t->high_pointer);
			// PTHREADS CREATE +++++++
			// +++++++++++++++++++++++ 
			pthread_rc = pthread_create(&thread[i],	&attribute, selection_sort, (void *)single_t);
			if (pthread_rc) 
			{
				printf("Error: Return code from pthread_create() is %d\n", pthread_rc);
				exit(-1);
     			}
			// +++++++++++++++++++++++
			//printf("Loop No. %d of %d\n", i, proc_no); 
		}		
	
		// PTHREADS DESTROY ++++++
		// +++++++++++++++++++++++ 
		pthread_attr_destroy(&attribute);
// !!! WARNING - This step is only for enhancing parallelism and not correctness !!! >>
		//for(pthread_t = 0; pthread_t < proc_no; pthread_t++) 
		for(pthread_t = 0; pthread_t < tmp_proc_val; pthread_t++) 
// !!! WARNING - This step is only for enhancing parallelism and not correctness !!! <<
		{
			pthread_rc = pthread_join(thread[pthread_t], &pthread_status);
			if (pthread_rc) 
			{
				printf("Return code from pthread_join() is %d\n", pthread_rc);
			}
		}
		// +++++++++++++++++++++++ 
/*
		for (i = 0; i < array_length; i++)
		{
			printf("Array Version{%d} [%d]: %d\n", proc_no, i, sort_array[i]);
		}
		printf("\n");
*/
		//proc_no--;
	}

	print_counters(perfEnd2);
	gettimeofday(&time_scan_run_end, NULL); // GET TIME
/*
	for (i = 0; i < array_length; i++)
	{
		printf("Final Array[%d]: %d\n", i, sort_array[i]);
	}
*/
	
	double success_counter = 0;
	int fail_counter = 0;
	for (i = 0; i < array_length; i++)
	{ 
		if (verify_array[i] != sort_array[i])
		{
			if (fail_counter < 10)
			{
				if (fail_counter == 0)
					printf("\n");
				//printf("   Fail: Verify[%d](%d) \t!=    Result[%d](%d)\n", i, verify_array[i], i, sort_array[i]);
			}
			else if (fail_counter == 10)
			{
				printf("\n      !!!WARNING!!! - LARGE NUMBER OF FAILURES\n");
			}
			fail_counter++;
		}
		else
		{
			success_counter++;
		}
	}

	// FREE MEMORY
	free(sort_array);
	free(verify_array);
	
	// END
	print_counters(perfMainEnd);
	gettimeofday(&time_end_main, NULL);
	double accuracy = (double)(success_counter*100/array_length);
	double total_time = (double)(time_end_main.tv_usec - time_begin_main.tv_usec)/1000000 
			  + (double)(time_end_main.tv_sec - time_begin_main.tv_sec);
	double verify_time = (double)(time_scan_verify_end.tv_usec - time_scan_verify_begin.tv_usec)/1000000 
			   + (double)(time_scan_verify_end.tv_sec - time_scan_verify_begin.tv_sec);
	double run_time = (double)(time_scan_run_end.tv_usec - time_scan_run_begin.tv_usec)/1000000 
			 + (double)(time_scan_run_end.tv_sec - time_scan_run_begin.tv_sec);
	double speed_up = (double)(verify_time)/(double)(run_time);

	total_time = total_time*1000000;
	verify_time = verify_time*1000000;
	run_time = run_time*1000000;
	
	// PRINT RESULTS
	printf("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++");
	printf("\n\t* TIMING STATS\n");
	printf("\t\tTOTAL  (T) :  %.0f\n", total_time);
	printf("\t\tVERIFY (V) :  %.0f (single)\n", verify_time);
	printf("\t\tSORT   (S) :  %.0f\n", run_time);
	printf("\n\t* PERFORMANCE STATS\n");
	printf("\t\tACCURACY   :  %f%%\n", accuracy);
	printf("\t\tSPEED UP   :  %f\n", speed_up);
	printf("\t\tRATIO S/T  :  %f\n", run_time/total_time);
	printf("\t\tRATIO V/T  :  %f\n", verify_time/total_time);
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
                        printf("\n\t\tVERIFY     :  %llu", perfBegin1[0]);
                }
                else {
                        printf(":%llu", perfEnd1[i]-perfBegin1[i]);

                }
        }
        for (i = 0; i < 7; i++){
                if (i==0){
                        printf("\n\t\tSORT       :  %llu", perfBegin2[0]);
                }
                else {
                        printf(":%llu", perfEnd2[i]-perfBegin2[i]);
                }
        }
	printf("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
	printf("\n");
}


