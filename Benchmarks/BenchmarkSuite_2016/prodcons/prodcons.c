#include "prodcons.h"
#include "linked_list.h"
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

sem_t s;
sem_t full;
sem_t empty;
node * head_node;
const int NUM_ELEMENTS = 20;  //Maximum number of values in the list

int main(int argc, char ** argv)
{
  pthread_t producer_thread, consumer_thread;
  head_node = NULL;

  sem_init(&s, 0, 1);
  sem_init(&full, 0, NUM_ELEMENTS);
  sem_init(&empty, 0, NUM_ELEMENTS);

  //Drain the full semaphore
  int i = 0;
  for(i = 0; i < NUM_ELEMENTS; i++)
    sem_wait(&full);

  printf("Created semaphores in main\n");

  int err_code;

  err_code = pthread_create(&producer_thread, NULL, producer, (void *) 0);
  if(err_code != 0)
  {
    printf("Unable to create producer thread\n");
    exit(0);
  }

  err_code = pthread_create(&consumer_thread, NULL, consumer, (void *) 1);
  if(err_code != 0)
  {
    printf("Unable to create consumer thread\n");
    exit(0);
  }

  err_code = pthread_join(producer_thread, NULL);
  if(err_code != 0)
  {
    printf("Unable to join producer thread\n");
    exit(0);
  }
  err_code = pthread_join(consumer_thread, NULL);
  if(err_code != 0)
  {
    printf("Unable to join consumer thread\n");
    exit(0);
  }

  sem_destroy(&s);
  sem_destroy(&full);
  sem_destroy(&empty);

  return 0;
}
