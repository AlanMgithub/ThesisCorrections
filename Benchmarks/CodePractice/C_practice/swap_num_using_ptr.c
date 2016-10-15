#include <stdio.h>

// SWAP NUMBERS USING POINTERS

void swap (int * ptr1, int * ptr2) {
	printf("Ptr1: %d, Ptr2: %d\n", *ptr1, *ptr2);
	*ptr1 = *ptr1 + *ptr2;
	*ptr2 = *ptr1 - *ptr2;
	*ptr1 = *ptr1 - *ptr2;
}

int main (void) {
	
	int inputVal1, inputVal2;
	int *one = &inputVal1;
	int *two = &inputVal2;

	printf("Two Values: ");
	scanf("%d%d", one, two);

	//swap(&inputVal1, &inputVal2);
	swap(one, two);
	printf("Val1: %d, Val2: %d\n", inputVal1, inputVal2);

	return 0;
}
