#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <string.h>

//#include "perfCounters.h"
#include <inttypes.h>
#include <err.h>
#include <sys/param.h>
//#include <sys/cpuset.h>

//#include "generic_getPerfCounter.c"
#include "dummy_generic_getPerfCounter.c"

// ***********************
// STRUCTS
// ***********************
/*
struct perfCountStruct
{
        unsigned long long core_id_c;
        unsigned long long miss_c;
        unsigned long long hit_c;
        unsigned long long sync_ll_c;
        unsigned long long init_sc_c;
        unsigned long long tmiss_inv_c;
        unsigned long long thit_invhit_c;
};
*/

// ***********************
// FUNCTIONS 
// ***********************
// PRINT ERROR
void printerr(char *s)
{
        fprintf(stderr, "ERROR: %s\n", s);
}

// GENERATE RANDOM FILLED ARRAY
int * random_array_generator(int array_length, int *input_array)
{
        int i;
        int neg_count = 0;
        int pos_count = 0;

        for (i = 0; i < array_length; i++)
        {
                input_array[i] = ((rand() - rand()/2)<<1)/1000;
                if (input_array[i] < 0)
                        neg_count++;
                else
                        pos_count++;
        }

        return input_array;
}


