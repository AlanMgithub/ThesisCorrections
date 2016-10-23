#ifndef LINKED_LIST_H
#define LINKED_LIST_H

struct node
{
  int data;
  struct node * next;
};

typedef struct node node;

extern node * head_node;

void add(node **, int);
void remove_node(node **);
int get_last(node **);

#endif
