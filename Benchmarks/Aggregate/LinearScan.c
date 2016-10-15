/*
	LINEAR SCAN	

	The input array is used to generate a new array
	New array has the following property:

		Input Array = A_new
		Output Array = A_old	
		For 0 <= n <= max 

		A_new[n] = A_old[0] + A_old[1] ... + A_old[n] 
		or
		A_new[n] = A_old[n] + A_new[n-1]		

	Each new element is the sum of all previous elements
*/

// ***********************
// GLOBAL VARIABLES
// ***********************
struct linearScanParamiters
{
	int low_range_pointer;
	int high_range_pointer;
	int offset;
	int array_length;
	int *source_array;
	int *output_array;	
};

struct timeval 	time_begin_main, 
		time_end_main,
		time_scan_verify_begin,
		time_scan_verify_end,
		time_scan_run_begin,
		time_scan_run_end,
		time_scan_inter_begin,
		time_scan_inter_end,
		time_scan_offset_begin,
		time_scan_offset_end	
;

// ***********************
// FUNCTIONS 
// ***********************
void * linear_scan(void *input)
{
	int i;
	struct linearScanParamiters *var = input;
	int low_range_pointer = var->low_range_pointer;
	int high_range_pointer = var->high_range_pointer;
	int offset = var->offset;
	int array_length = var->array_length;
	int *source_array = var->source_array;
	int *output_array = var->output_array;

	if (offset == 0)
	{
		for (i = low_range_pointer; i <= high_range_pointer; i++)
		{
			if (i == 0)
			{
				output_array[i] = source_array[i];
			}
			else
			{
				output_array[i] = source_array[i] + output_array[i-1];
			}
		}
	}
	else
	{
		for (i = (low_range_pointer+1); i <= high_range_pointer; i++)
		{
			output_array[i] = output_array[i] + offset;
		}
	}
	
	free(input);
}

// ***********************
// MAIN
// ***********************
int linear_scan_test(int no_of_processors, int array_length)
{
	int i;
	// +++++++++++++++++++++++ 
	// CREATE PTHREAD AND INIT
	pthread_t thread[no_of_processors];
	int pthread_rc;
	long pthread_t;
	void *pthread_status;

	// ***********************
	// ALGORITHM BEGIN
	// ***********************
	gettimeofday(&time_begin_main, NULL); // GET TIME

	// GENERATE RANDOM ARRAY
	int *source_array;
	source_array = malloc(array_length * sizeof(int));
	if (source_array == NULL)
	{
		printerr("Failed to allocate memory, source_array = malloc(array_length * sizeof(int));");
		return 1;
	}
	//printf("Debug: source_array = malloc(array_length * sizeof(int));\n");
	
	random_array_generator(array_length, source_array);
	//printf("Debug: random_array_generator(array_length, source_array);\n");

	// CREATE WORKING ARRAY
	int *output_array;
	output_array = malloc(array_length * sizeof(int));
	if (output_array == NULL)
	{
		printerr("Failed to allocate memory, output_array = malloc(array_length * sizeof(int));");
		return 1;
	}
	//printf("Debug: output_array = malloc(array_length * sizeof(int));\n");

	int low_range_pointer = 0;
	int high_range_pointer = array_length - 1;

	// DEFAULT CHECK FOR CORRECTNESS WITH A SINGLE INSTANCE RUN
	int *verify_array;
	verify_array = malloc(array_length * sizeof(int));
	if (verify_array == NULL)
	{
		printerr("Failed to allocate memory, output_array = malloc(array_length * sizeof(int));");
		return 1;
	}
	//printf("Debug: verify_array = malloc(array_length * sizeof(int));\n");

	gettimeofday(&time_scan_verify_begin, NULL); // GET TIME

	struct linearScanParamiters *verify;
	verify = malloc(sizeof(*verify));
	verify->low_range_pointer = low_range_pointer;
	verify->high_range_pointer = high_range_pointer;
	verify->offset = 0;
	verify->array_length = array_length;
	verify->source_array = source_array;
	verify->output_array = verify_array;
	
	// CREATE VERIFY ARRAY
	linear_scan(verify);

	gettimeofday(&time_scan_verify_end, NULL); // GET TIME

	// MULTICORE RUN OF THE ALGORITHM
	int n = array_length/no_of_processors;
	gettimeofday(&time_scan_run_begin, NULL); // GET TIME
	for (i = 0; i < no_of_processors; i++)
	//for (i = (no_of_processors-1); i >= 0; i--)
	{
		low_range_pointer = i*n;
		high_range_pointer = (i + 1)*n;
		// ENSURE TOP INDEX ARRAY ELEMENTS ARE CALCULATED
		if (i == (no_of_processors-1))
		{
			high_range_pointer = array_length - 1;
		}
	
		// BUILD STRUCT	
		struct linearScanParamiters *multi_t;
		multi_t = malloc(sizeof(*multi_t));
		multi_t->low_range_pointer = low_range_pointer;
		multi_t->high_range_pointer = high_range_pointer;
		multi_t->offset = 0;
		multi_t->array_length = array_length;
		multi_t->source_array = source_array;
		multi_t->output_array = output_array;

		// WITHOUT PTHREADS
		//linear_scan(multi_t);

		// PTHREADS CREATE +++++++
		// +++++++++++++++++++++++ 
		pthread_rc = pthread_create(&thread[i],	NULL, linear_scan, (void *)multi_t);
		if (pthread_rc) 
		{
			printf("Error: Return code from pthread_create() is %d\n", pthread_rc);
			exit(-1);
		}
		// +++++++++++++++++++++++ 
	}

	// PTHREADS DESTROY ++++++
	// +++++++++++++++++++++++ 
	for(pthread_t = 0; pthread_t < no_of_processors; pthread_t++) 
	{
		pthread_rc = pthread_join(thread[pthread_t], &pthread_status);
		if (pthread_rc) 
		{
			printf("FIRST RUN: Return code from pthread_join() is %d\n", pthread_rc);
		}
		//printf("Debug: 1 - pthread_rc = pthread_join(thread[%ld], &pthread_status);\n", pthread_t);
	}
	// +++++++++++++++++++++++ 

	gettimeofday(&time_scan_run_end, NULL); // GET TIME

	// CALCULATE OFFSET
	gettimeofday(&time_scan_inter_begin, NULL); // GET TIME

	int offset[no_of_processors-2];
	for (i = 0; i <= (no_of_processors-2); i++)
	{
		if (i == 0)
		{
			offset[i] = output_array[(i+1)*n-1];
		}
		else
		{
			offset[i] = output_array[(i+1)*n-1] + offset[i-1];
		}
	}
	//printf("Debug: offset calc\n");
	gettimeofday(&time_scan_inter_end, NULL); // GET TIME

	// APPLY OFFSET
	gettimeofday(&time_scan_offset_begin, NULL); // GET TIME

	for (i = 0; i < (no_of_processors-1); i++)
	{
		low_range_pointer = (i + 1)*n;
		high_range_pointer = ((i + 1) + 1)*n;
		// ENSURE TOP INDEX ARRAY ELEMENTS ARE CALCULATED
		if (i == (no_of_processors-2))
		{
			high_range_pointer = array_length - 1;
		}

		// BUILD STRUCT
		struct linearScanParamiters *multi_t;
		multi_t = malloc(sizeof(*multi_t));
		multi_t->low_range_pointer = low_range_pointer;
		multi_t->high_range_pointer = high_range_pointer;
		multi_t->offset = offset[i];
		multi_t->array_length = array_length;
		multi_t->source_array = NULL;
		multi_t->output_array = output_array;

		// WITHOUT PTHREADS
		//linear_scan(multi_t);
	
		// PTHREADS CREATE +++++++
		// +++++++++++++++++++++++ 

		pthread_rc = pthread_create(&thread[i],	NULL, linear_scan, (void *)multi_t);
		if (pthread_rc) 
		{
			printf("Error: Return code from pthread_create() is %d\n", pthread_rc);
			exit(-1);
     		}
		// +++++++++++++++++++++++ 
	}

	// PTHREADS DESTROY ++++++
	// +++++++++++++++++++++++ 
	for(pthread_t = 0; pthread_t < no_of_processors-1; pthread_t++) 
	{
		pthread_rc = pthread_join(thread[pthread_t], &pthread_status);
		if (pthread_rc) 
		{
			printf("OFFSET RUN: Return code from pthread_join() is %d\n", pthread_rc);
		}
		//printf("Debug: 3 - pthread_rc = pthread_join(thread[%ld], &pthread_status);\n", pthread_t);
	}
	// +++++++++++++++++++++++ 

	gettimeofday(&time_scan_offset_end, NULL); // GET TIME
	
	double success_counter = 0;
	int fail_counter = 0;
	for (i = 0; i < array_length; i++)
	{ 
		if (verify_array[i] != output_array[i])
		{
			if (fail_counter < 10)
			{
				if (fail_counter == 0)
					printf("\n");
				//printf("   Fail: Verify[%d](%d) \t!=    Result[%d](%d)\n", i, verify_array[i], i, output_array[i]);
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
	free(source_array);
	free(verify_array);
	free(output_array);
	
	// END
	gettimeofday(&time_end_main, NULL);
	double accuracy = (double)(success_counter*100/array_length);
	double total_time = (double)(time_end_main.tv_usec - time_begin_main.tv_usec)/1000000 
			  + (double)(time_end_main.tv_sec - time_begin_main.tv_sec);
	double verify_time = (double)(time_scan_verify_end.tv_usec - time_scan_verify_begin.tv_usec)/1000000 
			   + (double)(time_scan_verify_end.tv_sec - time_scan_verify_begin.tv_sec);
	double run_time = (double)(time_scan_run_end.tv_usec - time_scan_run_begin.tv_usec)/1000000 
			 + (double)(time_scan_run_end.tv_sec - time_scan_run_begin.tv_sec);
	double inter_time = (double)(time_scan_inter_end.tv_usec - time_scan_inter_begin.tv_usec)/1000000 
			 + (double)(time_scan_inter_end.tv_sec - time_scan_inter_begin.tv_sec);
	double offset_time = (double)(time_scan_offset_end.tv_usec - time_scan_offset_begin.tv_usec)/1000000 
			   + (double)(time_scan_offset_end.tv_sec - time_scan_offset_begin.tv_sec);
	double speed_up = (verify_time)/(run_time + offset_time + inter_time);

	total_time = total_time*1000000;
	verify_time = verify_time*1000000;
	run_time = run_time*1000000;
	inter_time = inter_time*1000000;
	offset_time = offset_time*1000000;
	
	// PRINT RESULTS
	printf("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++");
	printf("\n\t* TIMING STATS\n");
	printf("\t\tTOTAL  (V) :  %.0f\n", total_time);
	printf("\t\tVERIFY (T) :  %.0f (single)\n\n", verify_time);
	printf("\t\tSTAGE  (1) :  %.0f\n", run_time);
	printf("\t\tSTAGE  (2) :  %.0f\n", inter_time);
	printf("\t\tSTAGE  (3) :  %.0f\n", offset_time);
	printf("\t\tSTAGE  (S) :  %.0f\n", run_time+inter_time+offset_time);
	printf("\n\t* PERFORMANCE STATS\n");
	printf("\t\tACCURACY   :  %f%%\n", accuracy);
	printf("\t\tSPEED UP   :  %f\n", speed_up);
	printf("\t\tSTAGE (1)%% :  %f%%\n", (run_time*100)/(run_time+inter_time+offset_time));
	printf("\t\tSTAGE (2)%% :  %f%%\n", (inter_time*100)/(run_time+inter_time+offset_time));
	printf("\t\tSTAGE (3)%% :  %f%%\n\n", (offset_time*100)/(run_time+inter_time+offset_time));
	printf("\t\tRATIO S/T  :  %f\n", (run_time+inter_time+offset_time)/total_time);
	printf("\t\tRATIO V/T  :  %f\n", verify_time/total_time);
	printf("+++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
	printf("\n");
}


