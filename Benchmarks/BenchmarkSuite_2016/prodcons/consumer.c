#include "prodcons.h"
#include "linked_list.h"
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <stdlib.h>

void * consumer(void * tid)
{
  int i = 0; 
  while(i < 100)
  {
    int item;

    //Wait on the full counter
    sem_wait(&full);

    //Wait on the mutex semaphore
    sem_wait(&s);

    //Remove an item from the buffer
    item = get_last(&head_node);

    remove_node(&head_node);

    printf("Consumed an item: %d\n", item);

    //Release the mutex semaphore
    sem_post(&s);

    //Post to the empty counter
    sem_post(&empty);
    i++;
  }
  pthread_exit(NULL);
}
