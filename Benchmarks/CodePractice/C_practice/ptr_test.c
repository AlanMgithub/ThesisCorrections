#include <stdio.h>
#include <stdlib.h>

// POINTER TEST

int main (void) {
	int outputVal = 17;
	int *inputVal = &outputVal;

	*inputVal += 1;
	
	//outputVal++;
	//--outputVal;

	printf("Val: %d\n", outputVal);	

	int i = 10;
	inputVal = malloc(i*sizeof(int));

	if (inputVal == NULL)
		return -1;

	for (i-1; i >= 0; i--) {
		inputVal = &outputVal;
	}

	for (i = 0; i < 10; i++) {
		printf("InputVar[%d]: %d\n", i, *(inputVal+i));
	}

	free(inputVal);

	return 0;
}
