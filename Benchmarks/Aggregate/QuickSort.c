/*
	QUICK SORT	

	Sorts an array of elements in asending order
*/

// ***********************
// GLOBAL VARIABLES
// ***********************
struct quickSortParamiters
{
	int low_pointer;
	int high_pointer;
	int pivot_pointer;
	int array_length;
	int *sort_array;
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
unsigned int rand_interval(unsigned int min, unsigned int max)
{
    int r;
    const unsigned int range = 1 + max - min;
    const unsigned int buckets = RAND_MAX / range;
    const unsigned int limit = buckets * range;

    /* Create equal size buckets all in a row, then fire randomly towards
     * the buckets until you land in one of them. All buckets are equally
     * likely. If you land off the end of the line of buckets, try again. */
    do
    {
        r = rand();
    } while (r >= limit);

    return min + (r / buckets);
}

void * quick_sort(void *input)
{
	int i;
	struct quickSortParamiters *var = input;
	int low_pointer = var->low_pointer;
	int high_pointer = var->high_pointer;
	int array_length = var->array_length;
	int *sort_array = var->sort_array;

	int pivot_pointer = var->pivot_pointer;
	int pivot_value = sort_array[pivot_pointer];
	int store_pointer = low_pointer;


	sort_array[pivot_pointer] = sort_array[high_pointer];
	sort_array[high_pointer] = pivot_value;

	for (i = 0; i < high_pointer; i++)
	{
		if (sort_array[i] < pivot_value)
		{
			int tmp;
			tmp = sort_array[store_pointer];
			sort_array[store_pointer] = sort_array[i];
			sort_array[i] = tmp;
			store_pointer++;	
		}
	}
	int tmp = sort_array[store_pointer];
	sort_array[store_pointer] = sort_array[high_pointer];	
	sort_array[high_pointer] = tmp;

	//printf("store_pointer = %d\n", sort_array[array_length+1]);
	
	return sort_array;
}

// ***********************
// MAIN
// ***********************
int quick_sort_test(int no_of_processors, int array_length)
{
	int i;

	// PRINT INITAL SETUP
	printf("\n-----------------------------------------------------");
	printf("\n\t\t* INPUT PARAMETERS *\n\n");
	printf("\t\tPROC COUNT  : %d\n", no_of_processors);
	printf("\t\tWORK LENGTH : %d\n", array_length);
	printf("-----------------------------------------------------\n");

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

	gettimeofday(&time_scan_verify_begin, NULL); // GET TIME

	struct quickSortParamiters *verify;
	verify = malloc(sizeof(*verify));
	verify->low_pointer = low_pointer;
	verify->high_pointer = high_pointer;
	verify->array_length = array_length;
	verify->sort_array = sort_array;
/*
	// CREATE VERIFY ARRAY
	quick_sort(verify);
	
	for (i = 0; i < array_length; i++)
	{
		printf("Sort Array[%d]: %d\n", i, sort_array[i]);
	}
*/

	gettimeofday(&time_scan_verify_end, NULL); // GET TIME

	// MULTICORE RUN OF THE ALGORITHM
	if (no_of_processors == 1)
	{
		gettimeofday(&time_scan_run_begin, NULL); // GET TIME

		// BUILD STRUCT
		struct quickSortParamiters *single_t;
		single_t = malloc(sizeof(*single_t));
		single_t->low_pointer = low_pointer;
		single_t->high_pointer = high_pointer;
		single_t->array_length = array_length;
		single_t->sort_array = sort_array;

		// WITHOUT P-THREADS

		if (low_pointer < high_pointer)
		{
			quick_sort(single_t);
		}

		for (i = 0; i < array_length; i++)
		{
			printf("Final Array[%d]: %d\n", i, sort_array[i]);
		}

/*
		// PTHREADS CREATE +++++++
		// +++++++++++++++++++++++ 
		pthread_t = no_of_processors - 1;
		pthread_rc = pthread_create(&thread[pthread_t],	&attribute, quick_sort, (void *)single_t);
		if (pthread_rc) 
		{
			printf("Error: Return code from pthread_create() is %d\n", pthread_rc);
			exit(-1);
     		}
		// +++++++++++++++++++++++ 

		// PTHREADS DESTROY ++++++
		// +++++++++++++++++++++++ 
		pthread_attr_destroy(&attribute);
		for(pthread_t = 0; pthread_t < no_of_processors; pthread_t++) 
		{
			pthread_rc = pthread_join(thread[pthread_t], &pthread_status);
			if (pthread_rc) 
			{
				printf("Return code from pthread_join() is %d\n", pthread_rc);
			}
		}
		// +++++++++++++++++++++++ 
*/
		gettimeofday(&time_scan_run_end, NULL); // GET TIME

	}
	else
	{
		int n = array_length/no_of_processors;
		gettimeofday(&time_scan_run_begin, NULL); // GET TIME
		for (i = 0; i < no_of_processors; i++)
		//for (i = (no_of_processors-1); i >= 0; i--)
		{
			low_pointer = i*n;
			high_pointer = (i + 1)*n;
			// ENSURE TOP INDEX ARRAY ELEMENTS ARE CALCULATED
			if (i == (no_of_processors-1))
			{
				high_pointer = array_length - 1;
			}
		
			// BUILD STRUCT	
			struct quickSortParamiters *multi_t;
			multi_t = malloc(sizeof(*multi_t));
			multi_t->low_pointer = low_pointer;
			multi_t->high_pointer = high_pointer;
			multi_t->array_length = array_length;
			multi_t->sort_array = sort_array;

			// WITHOUT PTHREADS
			//quick_sort(multi_t);

			// PTHREADS CREATE +++++++
			// +++++++++++++++++++++++ 
			pthread_rc = pthread_create(&thread[i],	&attribute, quick_sort, (void *)multi_t);
			if (pthread_rc) 
			{
				printf("Error: Return code from pthread_create() is %d\n", pthread_rc);
				exit(-1);
     			}
			// +++++++++++++++++++++++ 
		}

		// PTHREADS DESTROY ++++++
		// +++++++++++++++++++++++ 
		pthread_attr_destroy(&attribute);
		for(pthread_t = 0; pthread_t < no_of_processors; pthread_t++) 
		{
			pthread_rc = pthread_join(thread[pthread_t], &pthread_status);
			if (pthread_rc) 
			{
				printf("FIRST RUN: Return code from pthread_join() is %d\n", pthread_rc);
			}
		}
		// +++++++++++++++++++++++ 

		gettimeofday(&time_scan_run_end, NULL); // GET TIME

		// CALCULATE OFFSET

		// APPLY OFFSET
		for (i = 0; i <= (no_of_processors-2); i++)
		{
			low_pointer = (i + 1)*n;
			high_pointer = ((i + 1) + 1)*n;
			// ENSURE TOP INDEX ARRAY ELEMENTS ARE CALCULATED
			if (i == (no_of_processors-2))
			{
				high_pointer = array_length - 1;
			}

			// BUILD STRUCT
			struct quickSortParamiters *multi_t;
			multi_t = malloc(sizeof(*multi_t));
			multi_t->low_pointer = low_pointer;
			multi_t->high_pointer = high_pointer;
			multi_t->array_length = array_length;
			multi_t->sort_array = NULL;

			// WITHOUT PTHREADS
			//quick_sort(multi_t);
	
			// PTHREADS CREATE +++++++
			// +++++++++++++++++++++++ 
			//pthread_attr_init(&attribute);
			//pthread_attr_setdetachstate(&attribute, PTHREAD_CREATE_JOINABLE);

			pthread_rc = pthread_create(&thread[i],	&attribute, quick_sort, (void *)multi_t);
			if (pthread_rc) 
			{
				printf("Error: Return code from pthread_create() is %d\n", pthread_rc);
				exit(-1);
     			}
			// +++++++++++++++++++++++ 
		}

		// PTHREADS DESTROY ++++++
		// +++++++++++++++++++++++ 
		pthread_attr_destroy(&attribute);
		for(pthread_t = 0; pthread_t < no_of_processors-1; pthread_t++) 
		{
			pthread_rc = pthread_join(thread[pthread_t], &pthread_status);
			if (pthread_rc) 
			{
				printf("OFFSET RUN: Return code from pthread_join() is %d\n", pthread_rc);
			}
		}
		// +++++++++++++++++++++++ 
	}
/*	
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
				printf("   Fail: Verify[%d](%d) \t!=    Result[%d](%d)\n", i, verify_array[i], i, sort_array[i]);
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
	
	// END
	gettimeofday(&time_end_main, NULL);
	double accuracy = (double)(success_counter*100/array_length);
	double total_time = (double)(time_end_main.tv_usec - time_begin_main.tv_usec)/1000000 
			  + (double)(time_end_main.tv_sec - time_begin_main.tv_sec);
	double verify_time = (double)(time_scan_verify_end.tv_usec - time_scan_verify_begin.tv_usec)/1000000 
			   + (double)(time_scan_verify_end.tv_sec - time_scan_verify_begin.tv_sec);
	double run_time = (double)(time_scan_run_end.tv_usec - time_scan_run_begin.tv_usec)/1000000 
			 + (double)(time_scan_run_end.tv_sec - time_scan_run_begin.tv_sec);

	total_time = total_time*1000000;
	verify_time = verify_time*1000000;
	run_time = run_time*1000000;
	
	// PRINT RESULTS
	printf("\n\n+++++++++++++++++++++++++++++++++++++++++++++++++++++");
	printf("\n\t       * QUICKSORT COMPLETE *\n\n");
	printf("\n\t* TIMING STATS\n");
	printf("\t\tTOTAL  (V) :  %.0f\n", total_time);
	printf("\t\tVERIFY (T) :  %.0f (single)\n", verify_time);
	printf("\t\tSTAGE  (1) :  %.0f\n", run_time);
	printf("\t\tSTAGE  (2) :  %.0f\n", offset_time);
	printf("\t\tSTAGE  (S) :  %.0f\n", run_time+offset_time);
	printf("\n\t* PERFORMANCE STATS\n");
	printf("\t\tACCURACY   :  %f%%\n", accuracy);
	printf("\t\tSPEED UP   :  %f\n", speed_up);
	printf("\t\tRATIO 1/2  :  %f\n", run_time/offset_time);
	printf("\t\tRATIO 1/V  :  %f\n", run_time/verify_time);
	printf("\t\tRATIO 2/V  :  %f\n", offset_time/verify_time);
	printf("\t\tRATIO 1/T  :  %f\n", run_time/total_time);
	printf("\t\tRATIO 2/T  :  %f\n", offset_time/total_time);
	printf("\t\tRATIO S/T  :  %f\n", (run_time+offset_time)/total_time);
	printf("\t\tRATIO V/T  :  %f\n", verify_time/total_time);
	printf("+++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
	printf("\n");
*/
}


