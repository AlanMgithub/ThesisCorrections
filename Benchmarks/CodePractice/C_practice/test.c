#include<stdio.h>

int hcf(int bigVar, int smallVar) {
	int reminder = 1;
	int tmp = smallVar;
	while(reminder > 0) {
		reminder = bigVar % tmp;
		if (reminder == 0)
			reminder = smallVar % tmp;
		tmp--;
	}
 	
	return tmp+1;
}
	
int lcm(int bigVar, int smallVar) {
	int hcfVal = hcf(bigVar, smallVar);
	return (bigVar*smallVar/hcfVal); 
}

int main()
{
/*
    void *vp;
    char ch=74, *cp="JACK";
    int j=65;
    vp=&ch;
    printf("\n1:%c", *(char*)vp);
    vp=&j;
    printf("\n2:%c", *(int*)vp);
    vp=cp;
    printf("\n3:%s\n", (char*)vp+2);
*/

/*
	int num = 0;
	while(num == 0) {
		printf("\nInput a Number: ");
		scanf("%d", &num);
	}
	int tmp = num;
	int finalVar = 0;
	while(tmp > 0) {
		int inter = tmp % 10;
		tmp = tmp/10;
		finalVar = finalVar + inter;
	}
	printf("\nSum of Digits: %d\n\n", finalVar);

	if (!(num % 2))
		printf("Even Input\n");
	else
		printf("Odd Input\n");		
*/

/*
	int factorial = 1;
	int i = 1;
	while (i <= num) {
		factorial = factorial * i;
		i++;
	}
	printf("\nFactorial: %d\n\n", factorial);
*/
	
	// Input 2 values
	int varOne, varTwo;
	printf("Input two variables\nX = ");
	scanf("%d", &varOne);
	printf("Y = ");
	scanf("%d", &varTwo);

	// Highest common factor
	int answer = 0;
	if (varOne >= varTwo)	
		answer = hcf(varOne, varTwo);
	else
		answer = hcf(varTwo, varOne);

	printf("\nHighest Common Factor: %d\n", answer);

	// Lowest common multiplier
	printf("\nLowest Common Multiplier: %d\n", lcm(varOne, varTwo));

    return 0;
}
