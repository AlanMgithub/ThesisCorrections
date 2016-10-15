#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>
#include <unistd.h>

struct point {
   char	char_a;
   char	char_c;
   long	long_a;
   char char_b;
};

struct mod_point {
   char	char_a;
   char	char_b;
   char	char_c;
   char	char_d;
   long	long_a;
};

struct nmod_point {
   char	char_a;
   char	char_b;
   char	char_c;
   char	char_d;
};


#define DATA_SIZE 1000000

struct point mega[DATA_SIZE];

int main(void) {

    struct point new;

    printf("Sizeof char      : %d\n", sizeof(char));
    printf("Sizeof short     : %d\n", sizeof(short));
    printf("Sizeof int       : %d\n", sizeof(int));
    printf("Sizeof long      : %d\n", sizeof(long));
    printf("Sizeof float     : %d\n", sizeof(float));
    printf("Sizeof double    : %d\n", sizeof(double));
    printf("Sizeof my struct : %d\n", sizeof(new));
    printf("Sizeof my struct : %d\n", sizeof(mega));
    printf("\n");


    char *ptr = mega[0].char_a;
    int i;
    char tmp = 'a';
    for(i = 0; i < 10; i++)
    {
        printf("Tmp = %c val = %d\n", tmp, tmp);
        //&ptr == tmp;
	ptr = &tmp;
        printf("Ptr = %c loc = %lld\n", *ptr, &ptr);
        tmp++;
    }

    for(i = 0; i < 10; i++)
    {
	*ptr = 'a';
        ptr++;
    }

    for(i = 0; i < 10; i++)
    {
	printf("Address : %d %d %lld %lld\n", &mega[i].char_a, &mega[i].char_c, &mega[i].long_a, &mega[i].char_b);
	printf("Element : %d %d %d %d\n", mega[i].char_a, mega[i].char_c, mega[i].long_a, mega[i].char_b);
    }
 
    return 0;
}
