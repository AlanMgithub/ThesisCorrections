#include <stdio.h>

// PRIME NUMBERS

void primeCheck (int inputVal) {
	static int testVal = 2;
	int divisor = 3;
	int flag = 0;

	if (inputVal < 1)
		return;

	while (divisor < testVal) {
		if ((testVal % divisor) == 0)
			flag = 1;
		divisor++;
	}
	
	if (!flag) {
		printf("%d, ", testVal);
		inputVal--;
	}
	testVal++;

	primeCheck(inputVal);
}

int main (void) {
	int howManyPrimes = 0;

	printf("How many primes are needed: ");
	scanf("%d", &howManyPrimes);

	primeCheck(howManyPrimes);
/*
	printf("All these are prime: ");
	if (howManyPrimes >= 1) {
		printf("2, ");
	}

	int i = 1;
	int testForPrime = 3;
	int divisor = 2;
	while (i < howManyPrimes) {
		divisor = 2;
		int flag = 0;
		while (divisor < testForPrime) {
			if ((testForPrime % divisor) == 0)
				flag = 1;
			divisor++;
		}
		
		if (!flag) {
			printf("%d, ", testForPrime);
			i++;
		}

		testForPrime++;
	}	
*/	
	printf("\n");

	return 0;
}
