#include <sys/times.h>
#include <time.h>
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>

#define LOOP_TIME 100000000//500000

long long int tmsBegin1,tmsEnd1,tmsBegin2,tmsEnd2,tmsBegin3,tmsEnd3,tmsBegin4,tmsEnd4,tmsBegin5,tmsEnd5,tmsBegin6,tmsEnd6;

int array[70000];

void *aliasing_loop(void *param)
{
  int index_offset = *((int*)param);
  int i = 0;
  int count = 0;
  for(i=0; i<LOOP_TIME; i++)
  {  
    array[count] = i;
    array[count+index_offset] = i+1;
/*
    if (count >= 9)
      count = 0;
    else
      count++;
*/
  }
}

void *per_thread_aliasing(void *param)
{
  int index_offset = *((int*)param);
  int i = 0;
  for(i=0; i<LOOP_TIME; i++)
  {
    int tmp = array[index_offset];
    array[index_offset] = i;
  }
}

int main(void)
{
  printf("Enter Main\n");

  long long time1;
  long long time2;
  long long time3;
  long long time4;
  long long time5;
  long long time6;
  int i = 0;

  pthread_t     thread_1;
  pthread_t     thread_2;

/*
  printf("Step 1\n");

  tmsBegin1 = clock();

  int index_offset = 4096;
  //for (i=0; i<10; i++)
  {
    aliasing_loop((void*)&index_offset);
  }

  tmsEnd1 = clock();

  printf("Step 2\n");

  tmsBegin2 = clock();

  index_offset = 0;//64;
  //for (i=0; i<10; i++)
  {
    aliasing_loop((void*)&index_offset);
  }

  tmsEnd2 = clock();

  printf("Step 3\n");

  tmsBegin3 = clock();

  index_offset = 0;
  pthread_create(&thread_1, NULL, per_thread_aliasing, (void*)&index_offset);
  index_offset = 4096;
  pthread_create(&thread_2, NULL, per_thread_aliasing, (void*)&index_offset);
  pthread_join(thread_1, NULL);
  pthread_join(thread_2, NULL);

  tmsEnd3 = clock();

  printf("Step 4\n");

  tmsBegin4 = clock();

  index_offset = 0;
  pthread_create(&thread_1, NULL, per_thread_aliasing, (void*)&index_offset);
  pthread_join(thread_1, NULL);
  index_offset = 4096;
  pthread_create(&thread_1, NULL, per_thread_aliasing, (void*)&index_offset);
  pthread_join(thread_1, NULL);

  tmsEnd4 = clock();

  printf("Step 5\n");

  tmsBegin5 = clock();

  index_offset = 0;
  pthread_create(&thread_1, NULL, per_thread_aliasing, (void*)&index_offset);
  index_offset = 1024;
  pthread_create(&thread_2, NULL, per_thread_aliasing, (void*)&index_offset);
  pthread_join(thread_1, NULL);
  pthread_join(thread_2, NULL);

  tmsEnd5 = clock();

  printf("Step 6\n");

  tmsBegin6 = clock();

  index_offset = 0;
  pthread_create(&thread_1, NULL, per_thread_aliasing, (void*)&index_offset);
  pthread_join(thread_1, NULL);
  index_offset = 1024;
  pthread_create(&thread_1, NULL, per_thread_aliasing, (void*)&index_offset);
  pthread_join(thread_1, NULL);

  tmsEnd6 = clock();

//*/
///*
  for (i=0; i<8192; i=i+1)
  {
    tmsBegin1 = clock();
    int index_offset = i;
    aliasing_loop((void*)&index_offset);
    //per_thread_aliasing((void*)&index_offset);
    tmsEnd1 = clock();
    time1 = (tmsEnd1-tmsBegin1)*1000/CLOCKS_PER_SEC;
    printf("Cache Aliasing (%d offset) : %lld ms\n", index_offset, time1);
  }
//*/
/*
  time1 = (tmsEnd1-tmsBegin1)*1000/CLOCKS_PER_SEC;
  time2 = (tmsEnd2-tmsBegin2)*1000/CLOCKS_PER_SEC;
  time3 = (tmsEnd3-tmsBegin3)*1000/CLOCKS_PER_SEC;
  time4 = (tmsEnd4-tmsBegin4)*1000/CLOCKS_PER_SEC;
  time5 = (tmsEnd5-tmsBegin5)*1000/CLOCKS_PER_SEC;
  time6 = (tmsEnd6-tmsBegin6)*1000/CLOCKS_PER_SEC;

  printf("Cache Aliasing     (4096 offset)  : %lld ms\n", time1);
  printf("Cache Non Aliasing (0 offset)     : %lld ms\n", time2);
  printf("Cache dual p-thread Aliasing      : %lld ms\n", time3);
  printf("Cache single p-thread Aliasing    : %lld ms\n", time4);
  printf("Cache dual p-thread Non Aliasing  : %lld ms\n", time5);
  printf("Cache single p-thread Non Aliasing: %lld ms\n", time6);
//*/
}
