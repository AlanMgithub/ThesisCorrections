#include <stdio.h>

int recursive (int value) {
	int nValue = value;
	if (nValue <= 1) {
		return 1;
	}
	nValue = nValue*recursive(nValue-1);	
	return nValue;
}

int messyRecursion (int value) {
	printf("messyRecursion Value: %d\n", value);
	if (value <= 0) {
		return 0;
	}
	printf("Fun(1)[%d]: ", value);
	messyRecursion(--value);
	printf("Fun(2)[%d]: ", value);
	messyRecursion(--value);
	return 0;
}	

int main (void) {
	int value;

	printf("Enter Value: ");
	scanf("%d", &value);

	//printf("Factorial Result: %d\n", recursive(value));
	messyRecursion(value);
}
