/*
	PAIR SELECTION SORT	

	Sorts an array of elements in asending order
*/

// ***********************
// GLOBAL VARIABLES
// ***********************
struct pairSortParamiters
{
	int low_pointer;
	int high_pointer;
	int thread_count;
	int offset;
	int *input_array;
};

struct timeval 	time_begin_main, 
		time_end_main,
		time_sort_verify_begin,
		time_sort_verify_end,
		time_sort_run_begin,
		time_sort_run_end
;

// ***********************
// FUNCTIONS 
// ***********************
void * sub_sort_loop(void *input)
{
	int i, pin;
	struct pairSortParamiters *var = input;
	int low_pointer = var->low_pointer;
	int high_pointer = var->high_pointer;
	int j = var->offset;
	int *sort_array = var->input_array;

	pin = low_pointer;
	for (i = pin+1; i < high_pointer; i++)
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
	free(input);
}

void * pair_sort(void *input)
{
	int i;
	struct pairSortParamiters *var = input;
	int low_pointer = var->low_pointer;
	int high_pointer = var->high_pointer;
	int thread_count = var->thread_count;
	int *sort_array = var->input_array;

	// CALCULATE RANGE
	int chunk = high_pointer/thread_count;
	
	// +++++++++++++++++++++++ 
	// CREATE PTHREAD AND INIT
	pthread_t thread[thread_count];
	pthread_attr_t attribute;
	int pthread_rc;
	long pthread_t;

	pthread_attr_init(&attribute);
	pthread_attr_setdetachstate(&attribute, PTHREAD_CREATE_JOINABLE);
	// +++++++++++++++++++++++ 

	for (i = low_pointer; i < high_pointer; i++)
	{
		// CREATE STRUCT
		struct pairSortParamiters *packet;
		packet = malloc(sizeof(*packet));
		if (packet == 0)
                {
                	printf("ERROR: Out of memory\n");
                }
		packet->low_pointer = i*chunk;
		packet->high_pointer = (i + 1)*chunk;
		packet->thread_count = thread_count;
		packet->input_array = sort_array;
		packet->offset = i;

		// SPAWN PTHREADS	
		// PTHREADS CREATE +++++++
		// +++++++++++++++++++++++ 
		pthread_rc = pthread_create(&thread[i],	&attribute, sub_sort_loop, (void *)packet);
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
	for(pthread_t = low_pointer; pthread_t < high_pointer; pthread_t++) 
	{
		pthread_rc = pthread_join(thread[pthread_t], NULL);
		if (pthread_rc) 
		{
			printf("Return code from pthread_join() is %d\n", pthread_rc);
		}
	}
}
// ***********************
// MAIN
// ***********************
int pair_selection_sort_test(int no_of_processors, int array_length)
{
	int i;
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

	gettimeofday(&time_sort_verify_begin, NULL); // GET TIME


	struct pairSortParamiters *verify;
	verify = malloc(sizeof(*verify));
	verify->low_pointer = 0;
	verify->high_pointer = array_length;
	verify->thread_count = 1;
	verify->input_array = verify_array;

	// CREATE VERIFY ARRAY
	pair_sort(verify);
/*	
	for (i = 0; i < array_length; i++)
	{
		printf("Verify Array[%d]: %d\n", i, verify_array[i]);
	}
	printf("\n");
*/
	gettimeofday(&time_sort_verify_end, NULL); // GET TIME

	// MULTICORE RUN OF THE ALGORITHM
	gettimeofday(&time_sort_run_begin, NULL); // GET TIME

	// BUILD STRUCT
	struct pairSortParamiters *input_t;
	input_t = malloc(sizeof(*input_t));
	input_t->low_pointer = 0;
	input_t->high_pointer = array_length;
	input_t->thread_count = no_of_processors;
	input_t->input_array = sort_array;

	pair_sort(input_t);

	gettimeofday(&time_sort_run_end, NULL); // GET TIME
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

	// FREE MEMEORY
	free(sort_array);
	free(verify_array);
	
	// END
	gettimeofday(&time_end_main, NULL);
	double accuracy = (double)(success_counter*100/array_length);
	double total_time = (double)(time_end_main.tv_usec - time_begin_main.tv_usec)/1000000 
			  + (double)(time_end_main.tv_sec - time_begin_main.tv_sec);
	double verify_time = (double)(time_sort_verify_end.tv_usec - time_sort_verify_begin.tv_usec)/1000000 
			   + (double)(time_sort_verify_end.tv_sec - time_sort_verify_begin.tv_sec);
	double run_time = (double)(time_sort_run_end.tv_usec - time_sort_run_begin.tv_usec)/1000000 
			 + (double)(time_sort_run_end.tv_sec - time_sort_run_begin.tv_sec);
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


