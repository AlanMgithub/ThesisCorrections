/*
	BENCHMARK SUITE	
*/

#include "Library.h"
// TESTS
#include "LinearScan.c"
#include "BlockSelectionSort.c"
#include "BatcherMergeSort.c"
#include "PairSelectionSort.c"
#include "QuickSort.c"
#include "DenseLinearAlgebra.c"
#include "PrimeIdentity.c"

// ***********************
// DEFINES
// ***********************
#define DEFAULT_PROCESSORS	1
#define MAX_PROCESSORS		1000
#define MAX_ARRAY_LENGTH 	10000000
#define MIN_ARRAY_LENGTH 	1000

// ***********************
// GLOBAL VARIABLES
// ***********************
int no_of_processors = DEFAULT_PROCESSORS;
int array_length = MIN_ARRAY_LENGTH;
int choose_test = 0;
int iterations = 1;
int total_tests = 6;

// ***********************
// MAIN
// ***********************
int main(int argc, char **argv)
{
	int c, x, y;

	extern char *optarg;

	// MENU
	while ((c = getopt(argc, argv, "t:i:p:s:stoh")) != -1)
	{
		switch (c)
		{
			case 't': choose_test = atoi(optarg);
				break;
			case 'i': iterations = atoi(optarg);
				break;
			case 'p': no_of_processors = atoi(optarg);
				if (no_of_processors < 1 || no_of_processors > MAX_PROCESSORS)
				{
					printf("ERROR: (p) must be in range 1 <= p <= %d\n", MAX_PROCESSORS);
					exit(-1);
				}
				break;
			case 's': array_length = atoi(optarg);
				if (array_length < MAX_PROCESSORS || array_length > MAX_ARRAY_LENGTH)
				{
					printf("ERROR: (s) must be in range %d < s < %1d\n", MAX_PROCESSORS, MAX_ARRAY_LENGTH);
					exit(-1);
				}
				break;
			case 'h': printf("\nUsage: LINEARSCAN <options>\n");
				  printf("   -tT : T = tests to run\n");
				  printf("         -t0 = all tests (DEFAULT)\n");
				  printf("         -t1 = linear scan\n");
				  printf("         -t2 = block selection sort\n");
				  printf("         -t3 = pair selection sort\n");
				  printf("         -t4 = batcher merge sort\n");
				  printf("         -t5 = quick sort\n");
				  printf("         -t6 = dense linear algebra\n");
				  printf("         -t7 = prime identity\n");
				  printf("   -iI : I = number of test run iterations\n");
			  	  printf("   -pP : P = number of processors (1 <= P <= %d)\n", MAX_PROCESSORS);
			  	  printf("   -sS : S = input array length   (%d <= S <= %1d)\n", MAX_PROCESSORS, MAX_ARRAY_LENGTH);
				  printf("Default: LINEARSCAN -t%1d -i%1d -p%1d -s%1d\n\n", choose_test, iterations, DEFAULT_PROCESSORS, MAX_ARRAY_LENGTH);
				  exit(0);
		}
	}

	int linear_scan_factor = 1000;
	int block_sort_factor = 10;
	int pair_sort_factor = 0;
	int batcher_sort_factor = 10;
	int quick_sort_factor = 0;
	int dense_algebra_factor = 1;
	int prime_identity_factor = 1;

	printf("\n-----------------------------------------------------");
	printf("\n\t\t* INPUT PARAMETERS *\n\n");
	printf("\t    PROC COUNT  : %d\n", no_of_processors);
	printf("\t   LINEAR SCAN  : %d\n", linear_scan_factor*array_length);
	printf("\t    BLOCK SORT  : %d\n", block_sort_factor*array_length);
	printf("\t     PAIR SORT  : %d\n", pair_sort_factor*array_length);
	printf("\t  BATCHER SORT  : %d\n", batcher_sort_factor*array_length);
	printf("\t    QUICK SORT  : %d\n", quick_sort_factor*array_length);
	printf("\t DENSE ALGEBRA  : %d\n", dense_algebra_factor*array_length);
	printf("\tPRIME IDENTITY  : %d\n", prime_identity_factor*array_length);
	printf("-----------------------------------------------------\n\n");
	
	int length_factor;
	if (choose_test == 0)
	{
		for (y = 0; y < total_tests; y++)
		{
			choose_test ++;
			for (x = 0; x < iterations; x++)
			{
				switch (choose_test)
				{
					case 1: length_factor = linear_scan_factor*array_length;
						printf("\t\tLINEAR SCAN : %d\n", x);
						linear_scan_test(no_of_processors, length_factor);
						break;
					case 2: length_factor = block_sort_factor*array_length;
						printf("\t\tBLOCK SORT : %d\n", x);
						block_selection_sort_test(no_of_processors, length_factor);
						break;
					case 3: length_factor = pair_sort_factor*array_length;
						printf("\t\tPAIR SORT : %d\n", x);
						pair_selection_sort_test(no_of_processors, length_factor);
						break;
/*
// !!! CURRENTLY THE SAME AS BLOCK SORT: NEEDS MODIFICATION 
					case 4: length_factor = batcher_sort_factor*array_length;
						printf("\t\tBATCHER SORT : %d\n", x);
						batcher_merge_sort_test(no_of_processors, length_factor);
						break;
*/
/*					case 5: length_factor = quick_sort_factor*array_length;
						printf("\t\tQUICK SORT : %d\n", x);
						printf("\nERROR: NO TEST FOR OPTION -t%d\n", choose_test);
						printf("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"); 
						//quick_sort_test(no_of_processors, length_factor);
						break;
*/					case 6: length_factor = dense_algebra_factor*array_length;
						printf("\t\tDENSE LINEAR ALGEBRA : %d\n", x);
						dense_linear_algebra_test(no_of_processors, length_factor);
						break;
					case 7: length_factor = prime_identity_factor*array_length;
						printf("\t\tPRIME IDENTITY : %d\n", x);
						prime_identity(no_of_processors, length_factor);
						break;
/*					case 8: printf("\nERROR: NO TEST FOR OPTION -t%d\n", choose_test);
						break;
					default: linear_scan_test(no_of_processors, length_factor);
						break;
*/				}
			}
		}
	}
	else 
	{
		for (x = 0; x < iterations; x++)
		{
			switch (choose_test)
			{
				case 1: length_factor = linear_scan_factor*array_length;
					printf("\t\tLINEAR SCAN : %d\n", x);
					linear_scan_test(no_of_processors, length_factor);
					break;
				case 2: length_factor = block_sort_factor*array_length;
					printf("\t\tBLOCK SORT : %d\n", x);
					block_selection_sort_test(no_of_processors, length_factor);
					break;
				case 3: length_factor = pair_sort_factor*array_length;
					printf("\t\tPAIR SORT : %d\n", x);
					pair_selection_sort_test(no_of_processors, length_factor);
					break;
				case 4: length_factor = batcher_sort_factor*array_length;
					printf("\t\tBATCHER SORT : %d\n", x);
					batcher_merge_sort_test(no_of_processors, length_factor);
					break;
				case 5: length_factor = quick_sort_factor*array_length;
					printf("\t\tQUICK SORT : %d\n", x);
					printf("\nERROR: NO TEST FOR OPTION -t%d\n", choose_test);
					printf("\n+++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"); 
					//quick_sort_test(no_of_processors, length_factor);
					break;
				case 6: length_factor = dense_algebra_factor*array_length;
					printf("\t\tDENSE LINEAR ALGEBRA : %d\n", x);
					dense_linear_algebra_test(no_of_processors, length_factor);
					break;
				case 7: length_factor = prime_identity_factor*array_length;
					printf("\t\tPRIME IDENTITY : %d\n", x);
					prime_identity(no_of_processors, length_factor);
					break;
				case 8: printf("\nERROR: NO TEST FOR OPTION -t%d\n", choose_test);
					break;
				default: linear_scan_test(no_of_processors, length_factor);
					break;
			}
		}

	}

	printf("\n\n\t\t * END BENCHMARK *\n\n");
	
	// EXIT PTHREADS
	pthread_exit(NULL);
	return(0);
}


