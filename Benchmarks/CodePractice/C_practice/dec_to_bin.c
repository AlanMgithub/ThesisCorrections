#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// DECIMAL TO BINARY COVERSION 

int main (void) {
	
	int inputDecimal = 0; 
	printf("\nInput Decimal Value: ");
	scanf("%d", &inputDecimal);

	int i = 0;
	char * binaryCharArray = malloc(sizeof(int)*8 + 1);
	if (binaryCharArray == NULL) 
		return -1;	

	for (i = 0; i < 8*(sizeof(int)); i++) {
		binaryCharArray[i] = ((inputDecimal>>i) & 1) ? '1' : '0';	
	}
	binaryCharArray[i] = '\0';

	i = strlen(binaryCharArray) - 1;
	int j = 0;

	while (i>j) {
		char tmp = binaryCharArray[j];
		binaryCharArray[j] = binaryCharArray[i];
		binaryCharArray[i] = tmp;
		i--;
		j++;
	}	

	printf("Output Binary Representation: %s\n", binaryCharArray);

	i = strlen(binaryCharArray) - 1;
	j = 0;

	while (i>j) {
		char tmp = *(binaryCharArray+j);
		*(binaryCharArray+j) = *(binaryCharArray+i);
		*(binaryCharArray+i) = tmp;
		i--;
		j++;
	}

	printf("Output Binary Representation, Reversed Again: %s\n\n", binaryCharArray);

	free(binaryCharArray);

	return 0;
}
