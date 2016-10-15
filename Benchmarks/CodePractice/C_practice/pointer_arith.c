#include <stdio.h>
#include <stdlib.h>

// POINTER ARITHMETIC

int main (int argc, char * argv[]) {
	int i = 1;
	while (i < argc) {
		if (*argv[i] == 't') {
			printf("\nYup\n");
		}
		else {
			printf("\nNo Yup\n");
		}
		i++;
	}

	int valOne, valTwo;
	printf("Input Value 1 and then 2: ");
	scanf("%d %d", &valOne, &valTwo);
	
	int * pointerOne, *pointerTwo;

	pointerOne = &valOne;
	pointerTwo = &valTwo;

	printf("Answer: %d\n", *pointerOne + *pointerTwo);	
	printf("Pointers: %d, %d\n", pointerOne, pointerTwo);
	printf("Pointer Refs: %d, %d", *pointerOne, *pointerTwo);

	
	return 0;
}
