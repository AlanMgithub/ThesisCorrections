/*
	BATCHER MERGE SORT	

	Sorts an array of elements in asending order
*/

// ***********************
// GLOBAL VARIABLES
// ***********************
struct mergeSortParamiters
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
void * merge_sort(void *input)
{
	int i, j, pin;
	struct mergeSortParamiters *var = input;
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

	free(input);
}

// ***********************
// MAIN
// ***********************
int batcher_merge_sort_test(int no_of_processors, int array_length)
{
	int i;
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

	// GENERATE RANDOM ARRAY
	int *sort_array;
	sort_array = malloc((array_length) * sizeof(int));
	if (sort_array == NULL)
	{
		printerr("Failed to allocate memory, sort_array = malloc(array_length * sizeof(int));");
		return 1;
	}
	
	random_array_generator(array_length, sort_array);

	// DEFAULT CHECK FOR CORRECTNESS WITH A SINGLE INSTANCE RUN
	int *verify_array;
	verify_array = malloc(array_length * sizeof(int));
	if (verify_array == NULL)
	{
		printerr("Failed to allocate memory, verify_array = malloc(array_length * sizeof(int));");
		return 1;
	}

	for (i = 0; i < array_length; i++)
	{
		verify_array[i] = sort_array[i];
	}

	gettimeofday(&time_scan_verify_begin, NULL); // GET TIME


	struct mergeSortParamiters *verify;
	verify = malloc(sizeof(*verify));
	verify->low_pointer = 0;
	verify->high_pointer = array_length;
	verify->input_array = verify_array;

	// CREATE VERIFY ARRAY
	merge_sort(verify);

	gettimeofday(&time_scan_verify_end, NULL); // GET TIME

	// MULTICORE RUN OF THE ALGORITHM
	gettimeofday(&time_scan_run_begin, NULL); // GET TIME

	// WITH P-THREADS
	int proc_no = no_of_processors;
	while (proc_no > 0)
	{
		for (i = 0; i < proc_no; i++)
                {
			// BUILD STRUCT
			struct mergeSortParamiters *single_t;
			single_t = malloc(sizeof(*single_t));
			single_t->input_array = sort_array;
			int chunk = array_length/proc_no;
			single_t->low_pointer = i*chunk;
			single_t->high_pointer = (i + 1)*chunk;
			// ENSURE TOP INDEX ARRAY ELEMENTS ARE CALCULATED
	                if (i == proc_no-1)
			{
				single_t->high_pointer = array_length;
			}
			//printf("Pointer low: %d, high: %d\n", single_t->low_pointer, single_t->high_pointer);
			// PTHREADS CREATE +++++++
			// +++++++++++++++++++++++ 
			pthread_rc = pthread_create(&thread[i],	&attribute, merge_sort, (void *)single_t);
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
		for(pthread_t = 0; pthread_t < proc_no; pthread_t++) 
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
		proc_no--;
	}

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
	
	free(verify_array);
	free(sort_array);

	// END
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
	printf("\t\tTOTAL  (V) :  %.0f\n", total_time);
	printf("\t\tVERIFY (T) :  %.0f (single)\n", verify_time);
	printf("\t\tSORT   (S) :  %.0f\n", run_time);
	printf("\n\t* PERFORMANCE STATS\n");
	printf("\t\tACCURACY   :  %f%%\n", accuracy);
	printf("\t\tSPEED UP   :  %f\n", speed_up);
	printf("\t\tRATIO S/T  :  %f\n", run_time/total_time);
	printf("\t\tRATIO V/T  :  %f\n", verify_time/total_time);
	printf("+++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
	printf("\n");
}


