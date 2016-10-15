#include <stdio.h>
#include <stdlib.h>
#include <time.h>

//#define MEMBLOCSIZE ((2<<20)*500)//1000MB
#define MEMBLOCSIZE 1

struct timeval time_begin, time_end;

int readMemory( int* data, int* dataEnd, int numReads, int incrementPerRead ) {
  int accum = 0;
  int* ptr = data;

  while(1) {
    accum += *ptr;
    if( numReads-- == 0)
      return accum;

    ptr += incrementPerRead;

    if( ptr >= dataEnd )
      ptr = data;
  }
}

int main()
{
  struct timespec tstart={0,0}, tend={0,0};
  clock_gettime(CLOCK_MONOTONIC, &tstart);


  int* data = (int*)malloc(MEMBLOCSIZE);
  int* dataEnd = data+(MEMBLOCSIZE / sizeof(int));

  int numReads = 100000000;//(MEMBLOCSIZE / sizeof(int));
  int dummyTotal = 0;
  int increment = 1;
  int loop = 0;

  printf("\nBegin Test\n");

  clock_gettime(CLOCK_MONOTONIC, &tend);

  double unique_id = ((double)tend.tv_sec + tend.tv_nsec) - ((double)tstart.tv_sec + tstart.tv_nsec);
  printf("Unique ID %0.f seconds\n", unique_id);

  for( loop = 0; loop < 28; ++loop ) {
    int startTime = clock();
    clock_gettime(CLOCK_MONOTONIC, &tstart); // get start time
    //gettimeofday(&time_begin, NULL);

    dummyTotal += readMemory(data, dataEnd, numReads, increment);

    clock_gettime(CLOCK_MONOTONIC, &tend); // get end time
    //gettimeofday(&time_end, NULL);
    int endTime = clock();
    double deltaTime = (double)(endTime-startTime)/(double)(CLOCKS_PER_SEC);
    double total_time =  /*(double)(time_end.tv_usec - time_begin.tv_usec)/1000000
                         + (double)(time_end.tv_sec - time_begin.tv_sec);*/
			((double)tend.tv_sec + tend.tv_nsec) - ((double)tstart.tv_sec + tstart.tv_nsec);

    printf("id=%0.f\t T-time=%f time=%.2f byteIncrement=%d numReadLocations=%d numReads=%d\n",
      unique_id, total_time, deltaTime, increment*sizeof(int), MEMBLOCSIZE/(increment*sizeof(int)), numReads);

    increment *= 2;
  }
  //Use dummyTotal: make sure the optimizer is not removing my code...
  return dummyTotal == 666 ? 1: 0;
}
