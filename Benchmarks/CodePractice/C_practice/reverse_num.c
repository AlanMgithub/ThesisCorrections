#include <stdio.h>
#include <stdlib.h>

// REVERSE DECIMAL NUMBER

int main (void) {
	int inputNumber = 0;

	printf("\nInput Number: ");
	scanf("%d", &inputNumber);

	printf("Echo - Non Reversed Number: %d\n", inputNumber);

	int outputNumber = 0;//= inputNumber>>31;
	//outputNumber = outputNumber<<31;
	//inputNumber = inputNumber^outputNumber;
	//printf("Input Number Unsigned: %d\n", inputNumber);
	while (inputNumber != 0) {
		int reminder = inputNumber % 10;
		outputNumber = outputNumber*10 + reminder;
		inputNumber = (inputNumber - reminder)/10;
	}
 
	printf("Reversed Number: %d\n", outputNumber);

	return 0;	
}
