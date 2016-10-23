#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>

static void populateArray (size_t dimension, uint32_t array[]) {
	int i = 0;
	for (i = 0; i < dimension; i++) {
		//uint8_t tmp = rand();
		*(array + i) = i;//tmp;
	}
}

static void dlaFunction (size_t dimension, uint32_t element, uint32_t twoD_array[], uint32_t oneD_array[], uint32_t final_array[]) {
	printf("dlaFunction: %u\n", element);

	int i = 0;
	int tmp = 0;
	for (i = 0; i < dimension; i++) {
		tmp = tmp + (*(twoD_array + i))*(*(oneD_array + i));
		//printf("tmp:%u\n", tmp);
	}
	*(final_array + element) = tmp;
}	

int main (void) {
	printf("Start\n");
	
	size_t dimension = 10;
	int i = 0;

	uint32_t **twoD_array_ptr;
	twoD_array_ptr = (uint32_t **) malloc(dimension*sizeof(uint32_t *));
	for(i = 0; i < dimension; i++) {
		twoD_array_ptr[i] = (uint32_t *) malloc(dimension*sizeof(uint32_t));
		if (twoD_array_ptr[i] == NULL) {
			printf("Error: Faled to allocate memory twoD_array_ptr");
			return -1;
		}
		// Populate
		populateArray(dimension, twoD_array_ptr[i]);
	}
	// Print intial values
/*
	int j = 0;
	for(i = 0; i < dimension; i++) {
		for(j = 0; j < dimension; j++) {
			printf("2D[%d][%d]:%u,", i, j, twoD_array_ptr[i][j]);
		}
		printf("\n");
	}
*/

	uint32_t *oneD_array_ptr = (uint32_t *) malloc(dimension*sizeof(uint32_t));
	if (oneD_array_ptr == NULL) {
		printf("Error: Faled to allocate memory oneD_array_ptr");
		return -1;
	}
	// Populate
	populateArray(dimension, oneD_array_ptr);
	
	uint32_t *final_array_ptr = (uint32_t *) malloc(dimension*sizeof(uint32_t));
	if (final_array_ptr == NULL) {
		printf("Error: Faled to allocate memory final_array_ptr");
		return -1;
	}
	// Populate
	populateArray(dimension, final_array_ptr);
	
	// Call Function
	for(i = 0; i < dimension; i++) {
		dlaFunction(dimension, (uint32_t) i, twoD_array_ptr[i], oneD_array_ptr, final_array_ptr);
	}

	// Print answer
	for(i = 0; i < dimension; i++) {
		printf("final_array[%d]: %u\n", i, *(final_array_ptr + i));
	}

	// Free
	free(twoD_array_ptr);
	free(oneD_array_ptr);
	free(final_array_ptr);

	return 0;
}
