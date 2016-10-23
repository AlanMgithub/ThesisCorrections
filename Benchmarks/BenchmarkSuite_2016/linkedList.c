#include <stdio.h>
#include <stdlib.h>

typedef struct LinkedList {
	char data;
	struct LinkedList *next;
}LinkedList;

static void displayList (LinkedList *head) {
	printf("\n");
	while (head) {
		printf("Display: head: %p, head->data: %c\n", head, head->data);
		head = head->next;
	}
}

static void addListElement (LinkedList *head, char data) {
	while (head->next != NULL) {
		head = head->next;
	}

	LinkedList *newElement = (LinkedList*)calloc(1, sizeof(LinkedList));	
	if (newElement == NULL) printf("Error: newElement calloc is NULL\n");
	newElement->data = data;
	head->next = newElement;
	head = head->next;
}

static void removeListElement (LinkedList *head, char removeData) {
	printf("\n");
	LinkedList *previous = head;
	while (head != NULL) {
		if (head->data == removeData) {
			printf("Delete match: current head->data is %c, head is %p\n", head->data, head);
			head = head->next;
			break;
		}
		previous = head;
		head = head->next;
	}
	
	printf("Previous: previous->data is %c, previous is %p\n", previous->data, previous);
	previous->next = head;
	free(head);
}

int main (void) {
	LinkedList *myList = (LinkedList*)calloc(1, sizeof(LinkedList));	
	if (myList == NULL) printf("Error: myList calloc is NULL\n");
	char value = 'a';
	myList->data = value;

	int i;
	for (i = 0; i < 10; i++) {
		value++;
		addListElement(myList, value);
	}

	displayList(myList);	
/*
	value = 'a';
	for (i = 0; i < 9; i++) {
		value += 2;
		printf("\nDelete: %c\n", value);
		removeListElement(myList, value);
	}
*/
	char delElement;
	while (delElement != 'q') {
		printf("Element to delete: ");
		scanf("%s", &delElement);
		removeListElement(myList, delElement);
		displayList(myList);	
	}

	return 0;
}
