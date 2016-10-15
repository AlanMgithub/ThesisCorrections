#include <sys/times.h>
#include <time.h>
#include <stdio.h> 
#include <pthread.h> 
#include <stdlib.h>
#include <string.h>

long long int tmsBegin1,tmsEnd1,tmsBegin2,tmsEnd2,tmsBegin3,tmsEnd3,tmsBegin4,tmsEnd4;
/*
struct timeval  time_begin1,
                time_end1,
                time_begin2,
                time_end2,
                time_begin3,
                time_end3
;
*/
int array[100];

void *heavy_loop(void *param) { 
  int   index = *((int*)param);
  int   i;
  for (i = 0; i < 100000000; i++)
    array[index]+=3;
} 

int main(int argc, char *argv[]) { 
 
  printf("Enter Main\n");

  int       first_elem  = 0;
  int       bad_elem    = 1;
  int       good_elem   = 32;

///*
  long long time1;
  long long time2;
  long long time3;
  long long time4;
//*/
/*
  double time1;
  double time2;
  double time3;
*/
  pthread_t     thread_1;
  pthread_t     thread_2;

  printf("Step 1\n");

  tmsBegin3 = clock();
  //gettimeofday(&time_begin3, NULL); // GET TIME

  heavy_loop((void*)&first_elem);
  heavy_loop((void*)&bad_elem);

  tmsEnd3 = clock();
  //gettimeofday(&time_end3, NULL); // END TIME

  printf("Step 2\n");

  tmsBegin4 = clock();

  pthread_create(&thread_1, NULL, heavy_loop, (void*)&first_elem);
  pthread_join(thread_1, NULL);
  pthread_create(&thread_1, NULL, heavy_loop, (void*)&bad_elem);
  pthread_join(thread_1, NULL);

  tmsEnd4 = clock();

  printf("Step 3\n");

  tmsBegin1 = clock();
  //gettimeofday(&time_begin1, NULL); // GET TIME

  pthread_create(&thread_1, NULL, heavy_loop, (void*)&first_elem);
  pthread_create(&thread_2, NULL, heavy_loop, (void*)&bad_elem);
  pthread_join(thread_1, NULL);
  pthread_join(thread_2, NULL);

  tmsEnd1 = clock(); 
  //gettimeofday(&time_end1, NULL); // END TIME

  printf("Step 4\n");

  tmsBegin2 = clock();
  //gettimeofday(&time_begin2, NULL); // GET TIME

  pthread_create(&thread_1, NULL, heavy_loop, (void*)&first_elem);
  pthread_create(&thread_2, NULL, heavy_loop, (void*)&good_elem);
  pthread_join(thread_1, NULL);
  pthread_join(thread_2, NULL);

  tmsEnd2 = clock();
  //gettimeofday(&time_end2, NULL); // END TIME

  printf("%d %d %d\n", array[first_elem],array[bad_elem],array[good_elem]);

///*
  time1 = (tmsEnd1-tmsBegin1)*1000/CLOCKS_PER_SEC;
  time2 = (tmsEnd2-tmsBegin2)*1000/CLOCKS_PER_SEC;
  time3 = (tmsEnd3-tmsBegin3)*1000/CLOCKS_PER_SEC;
  time4 = (tmsEnd4-tmsBegin4)*1000/CLOCKS_PER_SEC;
//*/
/*
  time1 = (double)(time_end1.tv_usec - time_begin1.tv_usec)/1000000 + (double)(time_end1.tv_sec - time_begin1.tv_sec);
  time2 = (double)(time_end2.tv_usec - time_begin2.tv_usec)/1000000 + (double)(time_end2.tv_sec - time_begin2.tv_sec);
  time3 = (double)(time_end3.tv_usec - time_begin3.tv_usec)/1000000 + (double)(time_end3.tv_sec - time_begin3.tv_sec);

  time1 = time1*1000000;
  time2 = time2*1000000;
  time3 = time3*1000000;
*/
/*
  printf("%.0f ms\n", time1);
  printf("%.0f ms\n", time2);
  printf("%.0f ms\n", time3);
*/
  printf("Cache Line False Share : %lld ms\n", time1);
  printf("Cache Line Not Shared  : %lld ms\n", time2);
  printf("No p-threads           : %lld ms\n", time3);
  printf("Single p-thread        : %lld ms\n", time4);

  return 0; 
} 
