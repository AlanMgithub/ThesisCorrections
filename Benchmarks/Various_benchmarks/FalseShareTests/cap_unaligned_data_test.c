#include <sys/times.h>
#include <time.h>
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

long long int tmsBegin1,tmsEnd1,tmsBegin2,tmsEnd2,tmsBegin3,tmsEnd3,tmsBegin4,tmsEnd4;

__capability volatile int data[10000];
__capability volatile size = 10000;

void Munge8( void *data, uint32_t size ) {
    uint8_t *data8 = (uint8_t*) data;
    uint8_t *data8End = data8 + size;
    
    while( data8 != data8End ) {
        *data8++ = -*data8;
    }
}

void Munge16( void *data, uint32_t size ) {
    uint16_t *data16 = (uint16_t*) data;
    uint16_t *data16End = data16 + (size >> 1); /* Divide size by 2. */
    uint8_t *data8 = (uint8_t*) data16End;
    uint8_t *data8End = data8 + (size & 0x00000001); /* Strip upper 31 bits. */
    
    while( data16 != data16End ) {
        *data16++ = -*data16;
    }
    while( data8 != data8End ) {
        *data8++ = -*data8;
    }
}

void Munge32( void *data, uint32_t size ) {
    uint32_t *data32 = (uint32_t*) data;
    uint32_t *data32End = data32 + (size >> 2); /* Divide size by 4. */
    uint8_t *data8 = (uint8_t*) data32End;
    uint8_t *data8End = data8 + (size & 0x00000003); /* Strip upper 30 bits. */
    
    while( data32 != data32End ) {
        *data32++ = -*data32;
    }
    while( data8 != data8End ) {
        *data8++ = -*data8;
    }
}

void Munge64( void *data, uint32_t size ) {
    double *data64 = (double*) data;
    double *data64End = data64 + (size >> 3); /* Divide size by 8. */
    uint8_t *data8 = (uint8_t*) data64End;
    uint8_t *data8End = data8 + (size & 0x00000007); /* Strip upper 29 bits. */
    
    while( data64 != data64End ) {
        *data64++ = -*data64;
    }
    while( data8 != data8End ) {
        *data8++ = -*data8;
    }
}

int main(void) {
  printf("Enter Main\n");
  //int data[10000];
  //int size = 10000;
  int i = 0;
 
  printf("Step 1\n");
  tmsBegin1 = clock();  
  for (i = 0; i < 10000; i++) {
    Munge8(*data, size);
  }
  tmsEnd1 = clock();

  printf("Step 2\n");
  tmsBegin2 = clock();  
  for (i = 0; i < 10000; i++) {
    Munge16(*data, size);
  }
  tmsEnd2 = clock();

  printf("Step 3\n");
  tmsBegin3 = clock();  
  for (i = 0; i < 10000; i++) {
    Munge32(*data, size);
  }
  tmsEnd3 = clock();

  printf("Step 4\n");
  tmsBegin4 = clock();  
  for (i = 0; i < 10000; i++) {
    Munge64(*data, size);
  }
  tmsEnd4 = clock();

  long long time1 = (tmsEnd1-tmsBegin1)*1000/CLOCKS_PER_SEC;
  long long time2 = (tmsEnd2-tmsBegin2)*1000/CLOCKS_PER_SEC;
  long long time3 = (tmsEnd3-tmsBegin3)*1000/CLOCKS_PER_SEC;
  long long time4 = (tmsEnd4-tmsBegin4)*1000/CLOCKS_PER_SEC;

  printf("Munge 8 result  : %lld ms\n", time1);
  printf("Munge 16 result : %lld ms\n", time2);
  printf("Munge 32 result : %lld ms\n", time3);
  printf("Munge 64 result : %lld ms\n", time4);
}
