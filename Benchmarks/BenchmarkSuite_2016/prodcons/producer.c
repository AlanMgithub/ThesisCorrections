#include "linked_list.h"
#include "prodcons.h"
#include <semaphore.h>
#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>

void * producer(void * tid)
{
  int i = 0;
  while(i < 100)
  {
    //Create an item
    int item = rand() % 100;

    //Wait for the empty counter
    sem_wait(&empty);

    //Wait for the mutex semaphore
    sem_wait(&s);

    printf("Produced an item: %d\n", item);

    //Put the item in the buffer (the list)
    add(&head_node, item);

    //Post to the mutex semaphore
    sem_post(&s);

    //Post to the full counter
    sem_post(&full);
    i++;
  }
  pthread_exit(NULL);
}
