//prodcons.h
//
//Producer-Consumer global definitions including semaphores

#include <semaphore.h>

#ifndef PRODCONS_H
#define PRODCONS_H

//Define semaphore variables for use in multiple files.
extern sem_t s;
extern sem_t full;
extern sem_t empty;

extern const int NUM_ELEMENTS;

//Define producer and consumer thread prototypes.
void * producer(void *);
void * consumer(void *);

#endif
