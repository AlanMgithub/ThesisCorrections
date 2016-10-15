#include <sys/times.h>
#include <time.h>
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define TEST_LOOP 1//100000

long long int tmsBegin1,tmsEnd1,tmsBegin2,tmsEnd2,tmsBegin3,tmsEnd3,tmsBegin4,tmsEnd4;

struct timeval 
time1_begin, 
time1_end,
time2_begin, 
time2_end,
time3_begin, 
time3_end,
time4_begin, 
time4_end,
time5_begin, 
time5_end
;

char data[5000000];
uint32_t size = 5000000;
 
void *Munge8( void *data ) {
    uint8_t *data8 = (uint8_t*) data;
    uint8_t *data8End = data8 + size;
    
    while( data8 != data8End ) {
        *data8++ = -*data8;
    }
}

void *Munge16( void *data ) {
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

void *Munge32( void *data ) {
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

void *Munge64( void *data ) {
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
  int i,j,k = 0;

  pthread_t thread_1;
while(k < 10)
{
  for (j = 0; j < 8; j++) 
  {
	char test_set[30];
	int test_no;
  	gettimeofday(&time1_begin, NULL); 
	for (i = 0; i < TEST_LOOP; i++) {
		switch(j) {
			case 0: 
				//Munge8(data+1, size);
				pthread_create(&thread_1, NULL, Munge8, (void*)&data+1);
				pthread_join(thread_1, NULL);
				test_no = 8;
				//test_set = "unaligned";	
				break;
			case 1:
				//Munge16(data+1, size);
				pthread_create(&thread_1, NULL, Munge16, (void*)&data+1);
				pthread_join(thread_1, NULL);
				test_no = 16;
				//test_set = "unaligned";	
				break;
			case 2:
				//Munge32(data+1, size);
				pthread_create(&thread_1, NULL, Munge32, (void*)&data+1);
				pthread_join(thread_1, NULL);
				test_no = 32;
				//test_set = "unaligned";	
				break;
			case 3:
				//Munge64(data+1, size);
				pthread_create(&thread_1, NULL, Munge64, (void*)&data+1);
				pthread_join(thread_1, NULL);
				test_no = 64;
				//test_set = "unaligned";	
				break;
			case 4:
				//Munge8(data, size);
				pthread_create(&thread_1, NULL, Munge8, (void*)&data);
				pthread_join(thread_1, NULL);
				test_no = 8;
				///test_set = "aligned";	
				break;
			case 5:
				//Munge16(data, size);
				pthread_create(&thread_1, NULL, Munge16, (void*)&data);
				pthread_join(thread_1, NULL);
				test_no = 16;
				//test_set = "aligned";	
				break;
			case 6:
				//Munge32(data, size);
				pthread_create(&thread_1, NULL, Munge32, (void*)&data);
				pthread_join(thread_1, NULL);
				test_no = 32;
				//test_set = "aligned";	
			break;
			case 7:
				//Munge64(data, size);
				pthread_create(&thread_1, NULL, Munge64, (void*)&data);
				pthread_join(thread_1, NULL);
				test_no = 64;
				//test_set = "aligned";	
				break;
		}
	}
  	gettimeofday(&time1_end, NULL);
 	double time1 = (double)(time1_end.tv_usec - time1_begin.tv_usec)/1000000
        	       + (double)(time1_end.tv_sec - time1_begin.tv_sec);
  	time1 = time1*1000000;
  	printf("Munge %d %s result  : %.0f\n", test_no, test_set, time1);
  }

  printf("\nRound complete %d\n", k);
  k++;
}
/* 
  printf("Step 1\n");
  //tmsBegin1 = clock(); 
  gettimeofday(&time1_begin, NULL); 
  for (i = 0; i < TEST_LOOP; i++) {
    Munge8(data+1, size);
  }
  gettimeofday(&time1_end, NULL);
  //tmsEnd1 = clock();

  printf("Step 2\n");
  //tmsBegin2 = clock();  
  gettimeofday(&time2_begin, NULL); 
  for (i = 0; i < TEST_LOOP; i++) {
    Munge16(data+1, size);
  }
  gettimeofday(&time2_end, NULL);
  //tmsEnd2 = clock();

  printf("Step 3\n");
  //tmsBegin3 = clock();  
  gettimeofday(&time3_begin, NULL); 
  for (i = 0; i < TEST_LOOP; i++) {
    Munge32(data+1, size);
  }
  gettimeofday(&time3_end, NULL);
  //tmsEnd3 = clock();

  printf("Step 4\n");
  //tmsBegin4 = clock();  
  gettimeofday(&time4_begin, NULL); 
  for (i = 0; i < TEST_LOOP; i++) {
    Munge64(data+1, size);
  }
  gettimeofday(&time4_end, NULL);
  //tmsEnd4 = clock();

  //long long time1 = (tmsEnd1-tmsBegin1)*1000/CLOCKS_PER_SEC;
  //long long time2 = (tmsEnd2-tmsBegin2)*1000/CLOCKS_PER_SEC;
  //long long time3 = (tmsEnd3-tmsBegin3)*1000/CLOCKS_PER_SEC;
  //long long time4 = (tmsEnd4-tmsBegin4)*1000/CLOCKS_PER_SEC;

  double time1 = (double)(time1_end.tv_usec - time1_begin.tv_usec)/1000000
                 + (double)(time1_end.tv_sec - time1_begin.tv_sec);
  double time2 = (double)(time2_end.tv_usec - time2_begin.tv_usec)/1000000
                 + (double)(time2_end.tv_sec - time2_begin.tv_sec);
  double time3 = (double)(time3_end.tv_usec - time3_begin.tv_usec)/1000000
                 + (double)(time3_end.tv_sec - time3_begin.tv_sec);
  double time4 = (double)(time4_end.tv_usec - time4_begin.tv_usec)/1000000
                 + (double)(time4_end.tv_sec - time4_begin.tv_sec);

  time1 = time1*1000000;
  time2 = time2*1000000;
  time3 = time3*1000000;
  time4 = time4*1000000;

  printf("Munge 8 result  : %.0f\n", time1);
  printf("Munge 16 result : %.0f\n", time2);
  printf("Munge 32 result : %.0f\n", time3);
  printf("Munge 64 result : %.0f\n", time4);
*/
}
