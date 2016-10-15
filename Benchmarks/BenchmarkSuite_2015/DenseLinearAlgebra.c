/*
	DENSE LINEAR ALGEBRA	

	Matrix Multiplication	
*/

struct denseLinearAlgebraParamiters
{
	int array_length;
	int *input_vector;
	int *input_matrix;
	int *output_vector;
	int thread_count;
};

struct doCalculationParamiters 
{
	int array_length;
	int *input_vector;
	int *input_matrix;
	int *output_vector;
	int offset;
};

struct timeval 	time_begin_main, 
		time_end_main,
		time_dla_verify_begin,
		time_dla_verify_end,
		time_dla_run_begin,
		time_dla_run_end
;

// ***********************
// FUNCTIONS 
// ***********************
void * do_calculation(void *input)
{
	struct doCalculationParamiters *var = input;
	int array_length = var->array_length;
	int *input_vector = var->input_vector;
	int *input_matrix = var->input_matrix;
	int *output_vector = var->output_vector;
	int j = var->offset;

	int i;
	for (i = 0; i < array_length; i++)
	{
		int tmp = output_vector[j];
		output_vector[j] = output_vector[j] + input_vector[j]*input_matrix[(array_length*j)+i];
		//printf("out[%d](%d) = out[%d](%d) + inv[%d](%d)*inm[%d](%d)\n", j, output_vector[j], j, tmp, j, input_vector[j], (array_length*j)+i, input_matrix[(array_length*j)+i]);
	}
	//printf("out[%d](%d)\n", j, output_vector[j]);
	//printf("\n");

	free(input);
}

void * matrix_vector_multiply(void *input)
{
	int i, j;
	struct denseLinearAlgebraParamiters *var = input;
	int array_length = var->array_length;
	int *input_vector = var->input_vector;
	int *input_matrix = var->input_matrix;
	int *output_vector = var->output_vector;
	int thread_count = var->thread_count;
	
	int chunk = array_length/thread_count;
	int remainder = array_length % thread_count;
	//printf("chunk = %d, remainder = %d\n", chunk, remainder);
	
	// +++++++++++++++++++++++ 
	// CREATE PTHREAD AND INIT
	pthread_t thread[thread_count];
	pthread_attr_t attribute;
	int pthread_rc;
	long pthread_t;

	pthread_attr_init(&attribute);
	pthread_attr_setdetachstate(&attribute, PTHREAD_CREATE_JOINABLE);
	// +++++++++++++++++++++++ 
	int offset_state;
	for (i = 0; i < chunk; i++)
	{
		for (j = 0; j < thread_count; j++)
		{
			struct doCalculationParamiters *packet;
			packet = malloc(sizeof(*packet));
			if (packet == 0)
			{
				printf("ERROR: Out of memory\n");
			}
			packet->array_length = array_length;
			packet->input_vector = input_vector;
			packet->input_matrix = input_matrix;
			packet->output_vector = output_vector;
			packet->offset = i*thread_count + j;
			//printf("offset=%d, i=%d, j=%d\n", packet->offset, i, j);
			//do_calculation(packet);
			// PTHREADS CREATE +++++++
			// +++++++++++++++++++++++ 
			pthread_rc = pthread_create(&thread[j],	&attribute, do_calculation, (void *)packet);
			if (pthread_rc) 
			{
				printf("Error: Return code from pthread_create() is %d\n", pthread_rc);
				exit(-1);
     			}
			// +++++++++++++++++++++++
			offset_state = packet->offset;
		}		
	
		// PTHREADS DESTROY ++++++
		// +++++++++++++++++++++++ 
		pthread_attr_destroy(&attribute);
		for(pthread_t = 0; pthread_t < thread_count; pthread_t++) 
		{
			pthread_rc = pthread_join(thread[pthread_t], NULL);
			if (pthread_rc) 
			{
				printf("Return code from pthread_join() is %d\n", pthread_rc);
			}
		}
		// +++++++++++++++++++++++ 
	}

	offset_state++;
	if (remainder != 0)
	{
		for (i = 0; i < remainder; i++)
		{
			struct doCalculationParamiters *packet;
			packet = malloc(sizeof(*packet));
			if (packet == 0)
			{
				printf("ERROR: Out of memory\n");
			}
			packet->array_length = array_length;
			packet->input_vector = input_vector;
			packet->input_matrix = input_matrix;
			packet->output_vector = output_vector;
			packet->offset = offset_state;
			//printf("remainder=%d, i=%d\n", packet->offset, i);
			offset_state++;
			//do_calculation(packet);
			// PTHREADS CREATE +++++++
			// +++++++++++++++++++++++ 
			pthread_rc = pthread_create(&thread[i],	&attribute, do_calculation, (void *)packet);
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
		for(pthread_t = 0; pthread_t < remainder; pthread_t++) 
		{
			pthread_rc = pthread_join(thread[pthread_t], NULL);
			if (pthread_rc) 
			{
				printf("Return code from pthread_join() is %d\n", pthread_rc);
			}
		}
		// +++++++++++++++++++++++ 
	}
}

// ***********************
// MAIN
// ***********************
int dense_linear_algebra_test(int no_of_processors, int array_length)
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


	// ***********************
	// ALGORITHM BEGIN
	// ***********************
	gettimeofday(&time_begin_main, NULL); // GET TIME
	print_counters(perfMainBegin);
	
	// GENERATE RANDOM ARRAY
	int *input_vector;
	input_vector = malloc((array_length) * sizeof(int));
	if (input_vector == NULL)
	{
		printerr("Failed to allocate memory, input_vector = malloc(array_length * sizeof(int));");
		return 1;
	}
	
	random_array_generator(array_length, input_vector);

	// GENERATE RANDOM ARRAY
	int *input_matrix;
	input_matrix = malloc((array_length*array_length) * sizeof(int));
	if (input_matrix == NULL)
	{
		printerr("Failed to allocate memory, input_matrix = malloc((array_length*array_length) * sizeof(int));");
		return 1;
	}
	
	random_array_generator(array_length*array_length, input_matrix);






	// DEFAULT CHECK FOR CORRECTNESS WITH A SINGLE INSTANCE RUN
	gettimeofday(&time_dla_verify_begin, NULL); // GET TIME
	print_counters(perfBegin1);

	int *verify_vector;
	verify_vector = malloc(array_length * sizeof(int));
	if (verify_vector == NULL)
	{
		printerr("Failed to allocate memory, verify_vector = malloc(array_length * sizeof(int));");
		return 1;
	}

	struct denseLinearAlgebraParamiters *verify;
	verify = malloc(sizeof(*verify));
	if (verify == NULL)
	{
		printerr("Failed to allocate memory, verify = malloc(sizeof(*verify));");
		return 1;
	}
	verify->array_length = array_length;
	verify->input_vector = input_vector;
	verify->input_matrix = input_matrix;
	verify->output_vector = verify_vector;
	verify->thread_count = 1;

	// VERIFY ARRAY
	matrix_vector_multiply(verify);

	print_counters(perfEnd1);
	gettimeofday(&time_dla_verify_end, NULL); // GET TIME






	// DLB OUTPUT ARRAY
	gettimeofday(&time_dla_run_begin, NULL); // GET TIME
	print_counters(perfBegin2);

	int *dla_vector;
	dla_vector = malloc(array_length * sizeof(int));
	if (dla_vector == NULL)
	{
		printerr("Failed to allocate memory, dla_vector = malloc(array_length * sizeof(int));");
		return 1;
	}

	struct denseLinearAlgebraParamiters *dla;
	dla = malloc(sizeof(*dla));
	if (dla == NULL)
	{
		printerr("Failed to allocate memory, dla = malloc(sizeof(*dla));");
		return 1;
	}
	dla->array_length = array_length;
	dla->input_vector = input_vector;
	dla->input_matrix = input_matrix;
	dla->output_vector = dla_vector;
	dla->thread_count = no_of_processors;

	// DLB CALCULATION
	matrix_vector_multiply(dla);

	print_counters(perfEnd2);
	gettimeofday(&time_dla_run_end, NULL); // GET TIME






	// PERFORMANCE CALCULATION	
	double success_counter = 0;
	int fail_counter = 0;

	for (i = 0; i < array_length; i++)
	{ 
		if (verify_vector[i] != dla_vector[i])
		{
			if (fail_counter < 10)
			{
				if (fail_counter == 0)
					printf("\n");
				//printf("   Fail: Verify[%d](%d) \t!=    Result[%d](%d)\n", i, verify_vector[i], i, dla_vector[i]);
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
	free(input_vector);
	free(input_matrix);
	free(verify_vector);
	free(dla_vector);
	free(verify);
	free(dla);
	
	// END
	print_counters(perfMainEnd);
	gettimeofday(&time_end_main, NULL);
	double accuracy = (double)(success_counter*100/array_length);
	double total_time = (double)(time_end_main.tv_usec - time_begin_main.tv_usec)/1000000 
			  + (double)(time_end_main.tv_sec - time_begin_main.tv_sec);
	double verify_time = (double)(time_dla_verify_end.tv_usec - time_dla_verify_begin.tv_usec)/1000000 
			   + (double)(time_dla_verify_end.tv_sec - time_dla_verify_begin.tv_sec);
	double run_time = (double)(time_dla_run_end.tv_usec - time_dla_run_begin.tv_usec)/1000000 
			 + (double)(time_dla_run_end.tv_sec - time_dla_run_begin.tv_sec);
	double speed_up = (double)(verify_time)/(double)(run_time);

	total_time = total_time*1000000;
	verify_time = verify_time*1000000;
	run_time = run_time*1000000;
	
	// PRINT RESULTS
	printf("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++");
	printf("\n\t* TIMING STATS\n");
	printf("\t\tTOTAL  (T) :  %.0f\n", total_time);
	printf("\t\tVERIFY (V) :  %.0f (single)\n", verify_time);
	printf("\t\tDLB    (D) :  %.0f\n", run_time);
	printf("\n\t* PERFORMANCE STATS\n");
	printf("\t\tACCURACY   :  %f%%\n", accuracy);
	printf("\t\tSPEED UP   :  %f\n", speed_up);
	printf("\t\tRATIO D/T  :  %f\n", run_time/total_time);
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
                        printf("\n\t\tSTAGE      :  %llu", perfBegin2[0]);
                }
                else {
                        printf(":%llu", perfEnd2[i]-perfBegin2[i]);
                }
        }
	printf("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
	printf("\n");
}


