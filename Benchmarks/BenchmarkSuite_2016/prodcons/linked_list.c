#include "linked_list.h"
#include <stdlib.h>

void add(node ** head, int data)
{
  if(*head == NULL)
  {
    *head = (node *) malloc(sizeof(node));
    (*head)->data = data;
    (*head)->next = NULL;
  }
  else
  {
    node * temp = *head;
    while(temp->next != NULL)
      temp = temp->next;

    temp->next = (node *) malloc(sizeof(node));
    temp->next->data = data;
    temp->next->next = NULL;
  }
}

void remove_node(node ** head)
{
  node * prev;
  node * temp;
  if(*head != NULL)
  {
    prev = *head;
    temp = (*head)->next;

    if(temp == NULL)
    {
      prev = NULL;
      free((void *) *head);
      *head = NULL;
    }
    else
    {
      prev = *head;
      temp = (*head)->next;
      while(temp->next != NULL)
      {
        prev = temp;
        temp = temp->next;
      }

      free((void *) temp);
      temp = NULL;
      prev->next = NULL;
    }
  }
}

int get_last(node ** head)
{
  if(*head == NULL)
    return -1;
  else
  {
    node * temp = *head;

    while(temp->next != NULL)
      temp = temp->next;

    return temp->data;
  }
}
