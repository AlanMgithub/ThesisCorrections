#include <stdio.h>
#include <stdlib.h>
/*
int main (void) {
	char name[30];
	printf("Enter name: ");
	scanf("%s",name);
	printf("Your name is %s.\n",name);

	printf("Another name: ");
	gets(name);
	printf("\nYour name is ");
	puts(name);
	return 0;
}
*/

// STRUCT AND UNION TEST

struct arrayStruct {
	int intVar;
	char charVar;		
};

union arrayUnion {
	char someChar;

	struct {
		unsigned int bit0 : 1;
		unsigned int bit1 : 1;
		unsigned int bit2 : 1;
		unsigned int bit3 : 1;
		unsigned int bit4 : 1;
		unsigned int bit5 : 1;
		unsigned int bit6 : 1;
		unsigned int bit7 : 1;
	};

/*
	struct {
		unsigned int bit : 8;
	};
*/
};

int main(){

	struct arrayStruct mainArray;
	struct arrayStruct *ptrArray;

	mainArray.intVar = 1<<30;
	mainArray.charVar = 'a';

	ptrArray = &mainArray;
	printf("Init Struct Val: %d, %c\n", mainArray.intVar, mainArray.charVar);

	(*ptrArray).intVar = (*ptrArray).intVar>>1;	
	(*ptrArray).charVar += 1;	
	printf("Init Struct Ptr: %d, %c\n", (*ptrArray).intVar, (*ptrArray).charVar);

	printf("Lets tweak that struct, prtArray: int, char -> ");
	scanf("%d %c", &(ptrArray)->intVar, &(ptrArray)->charVar);

	printf("Modified struct, ptrArray: intVar: %d, charVar: %c\n", ptrArray->intVar, ptrArray->charVar);

	union arrayUnion unionArray;
	unionArray.someChar = 'A';

	printf("Union char: %c\n", unionArray.someChar);
	printf("Union char in binary: %d%d%d%d%d%d%d%d \n", unionArray.bit7, unionArray.bit6, unionArray.bit5, unionArray.bit4, unionArray.bit3, unionArray.bit2, unionArray.bit1, unionArray.bit0);
	//printf("Union char in binary: %d\n", unionArray.bit);
	printf("Union char in decimal: %d\n", unionArray.someChar);

	printf("Union Size: unionArray:%d, someChar:%d\n", sizeof(unionArray), sizeof(unionArray.someChar));
	
	return 0;
}
