/* File:     many_sems.c
 *
 * Purpose:  "Lock and unlock" a semaphore many times, and report on 
 *           elapsed time
 *
 * Compile:  gcc -g -Wall -o many_sems many_sems.c -lpthread
 * Run:      ./many_sems <thread_count> <n>
 *              n:  number of times the semaphore is locked and unlocked
 *                  by each thread
 *
 * Input:    none
 * Output:   Total number of times semaphore was locked and elapsed time for
 *           the threads
 *
 * Run-times with 4 threads and n = 10^6:
 *
 *   Penguin01:  no optimization
 *      many_mutexes:  7.59e-1 sec
 *      many_sems:     3.29    sec
 *
 *   Penguin01:  -O3 optimization
 *      many_mutexes:  6.96e-1 sec
 *      many_sems:     2.17    sec
 *
 *   Hr23502:  no optimization
 *      many_mutexes:  8.50e-1 sec
 *      many_sems:     1.89    sec
 *
 *   Hr23502:  -O3 optimization
 *      many_mutexes:  8.99e-1 sec
 *      many_sems:     8.66e-1 sec
 */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>

int thread_count;
int n;
int total = 0;
sem_t sem;

void Usage(char prog_name[]);
void* Lock_and_unlock(void* rank);

int main(int argc, char* argv[]) {
   pthread_t* thread_handles;
   long thread;
   double start, finish;

   if (argc != 3) Usage(argv[0]);
   thread_count = strtol(argv[1], NULL, 10);
   n = strtol(argv[2], NULL, 10);

   thread_handles = malloc(thread_count*sizeof(pthread_t));
   sem_init(&sem, 0, 1);

   GET_TIME(start);
   for (thread = 0; thread < thread_count; thread++)
      pthread_create(&thread_handles[thread], NULL, Lock_and_unlock,
            (void*) thread);

   for (thread = 0; thread < thread_count; thread++)
      pthread_join(thread_handles[thread], NULL);
   GET_TIME(finish);

   printf("Total number of times sem was locked and unlocked: %d\n",
         total);
   printf("Elapsed time = %e seconds\n", finish-start);

   sem_destroy(&sem);
   free(thread_handles);
   return 0;
}  /* main */

/*---------------------------------------------------------------------
 * Function:   Usage
 * Purpose:    Print a message explaining how to start the program.
 *             Then quit.
 * In arg:     prog_name:  name of program from command line
 */
void Usage(char prog_name[]) {
   fprintf(stderr, "usage: %s <thread_count> <n>\n", prog_name);
   fprintf(stderr, "    n: number of times semaphore is locked and ");
   fprintf(stderr, "unlocked by each thread\n");
   exit(0);
}  /* Usage */


/*---------------------------------------------------------------------
 * Function:   Lock_and_unlock
 * Purpose:    Repeatedly lock and unlock a semaphore to determine performance
 *             of semaphores
 * In arg:     rank:  thread rank
 * In globals: thread_count:  number of threads
 *             n:  number of times each thread should lock and unlock semaphore
 *             sem: the semaphore
 * In/out global:  total:  total number of times sem is locked and unlocked.
 */
void* Lock_and_unlock(void* rank) {
   long my_rank = (long) rank;  /* unused */
   int i;

   for (i = 0; i < n; i++) {
      sem_wait(&sem);
      total++;
      sem_post(&sem);
   }

   return NULL;
}  /* Lock_and_unlock */
