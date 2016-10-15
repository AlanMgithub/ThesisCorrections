#include <sys/times.h>
#include <time.h>
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>

long long int tmsBegin0,tmsEnd0,tmsBegin1,tmsEnd1,tmsBegin2,tmsEnd2,tmsBegin3,tmsEnd3,tmsBegin4,tmsEnd4;

struct foo {
    int w;
    int x; 
    int y; 
    int z; 

    int a; 
    int b; 
    int c; 
    int d; 

    int p; 
    int q; 
    int r; 
    int s; 
};
 
static struct foo f;
 
/* The two following functions are running concurrently: */
 
void *sum_a(void* param)
{
    int s = 0;
    int i;
    for (i = 0; i < 5000000; ++i)
        s += f.w;
    //return s;
}
 
void *inc_a(void* param)
{
    int i;
    for (i = 0; i < 5000000; ++i)
        ++f.c;
}
 
void *inc_b(void* param)
{
    int i;
    for (i = 0; i < 5000000; ++i)
        ++f.r;
}


int main (void)
{
  printf("Enter Main\n");

  int i = 0;
  int nothing = 0;
  pthread_t     thread_1;
  pthread_t     thread_2;

//***********************************************************
  printf("Step 0\n");

  tmsBegin0 = clock();
  for(i = 0;i < 10000; i++)
  {
    sum_a((void*)&nothing);
  }
  for(i = 0;i < 10000; i++)
  {
    inc_b((void*)&nothing);  
  }
  tmsEnd0 = clock();

//***********************************************************
  printf("Step 1\n");

  tmsBegin1 = clock();
  for(i = 0;i < 10000; i++)
  {
    sum_a((void*)&nothing);
    inc_b((void*)&nothing);  
  }
  tmsEnd1 = clock();

//***********************************************************
  printf("Step 2\n");

  tmsBegin2 = clock();
  for(i = 0;i < 10000; i++)
  {
    pthread_create(&thread_1, NULL, sum_a, (void*)&nothing);
    pthread_create(&thread_2, NULL, inc_b, (void*)&nothing);
    pthread_join(thread_1, NULL);
    pthread_join(thread_2, NULL);
  }
  tmsEnd2 = clock();

//***********************************************************
  printf("Step 3\n");

  tmsBegin3 = clock();
  for(i = 0;i < 10000; i++)
  {
    pthread_create(&thread_1, NULL, sum_a, (void*)&nothing);
    pthread_join(thread_1, NULL);
    pthread_create(&thread_1, NULL, inc_b, (void*)&nothing);
    pthread_join(thread_1, NULL);
  }
  tmsEnd3 = clock();

//***********************************************************
  printf("Step 4\n");

  tmsBegin4 = clock();
  for(i = 0;i < 10000; i++)
  {
    pthread_create(&thread_1, NULL, sum_a, (void*)&nothing);
    pthread_create(&thread_2, NULL, inc_a, (void*)&nothing);
    pthread_join(thread_1, NULL);
    pthread_join(thread_2, NULL);
  }
  tmsEnd4 = clock();



  long long time0 = (tmsEnd0-tmsBegin0)*1000/CLOCKS_PER_SEC;
  long long time1 = (tmsEnd1-tmsBegin1)*1000/CLOCKS_PER_SEC;
  long long time2 = (tmsEnd2-tmsBegin2)*1000/CLOCKS_PER_SEC;
  long long time3 = (tmsEnd3-tmsBegin3)*1000/CLOCKS_PER_SEC;
  long long time4 = (tmsEnd4-tmsBegin4)*1000/CLOCKS_PER_SEC;

  printf("No p-threads two loops  : %lld ms\n", time0);
  printf("No p-threads one loop   : %lld ms\n", time1);
  printf("Two p-thread            : %lld ms\n", time2);
  printf("Single p-thread         : %lld ms\n", time3);
  printf("Two p-thread aliasing   : %lld ms\n", time4);
}
