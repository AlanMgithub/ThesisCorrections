#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int global_array[100000];

void BubbleSort(int a[], int n)
{
	int i, j, temp;
	for (i = 0; i < (n - 1); ++i)
	{
		for (j = 0; j < n - 1 - i; ++j)
		{
			if (a[j] > a[j+1])
			{
				temp = a[j+1];
				a[j+1] = a[j];
				a[j] = temp;
			}
		}
	}
}

int main(void)
{

	int tmp_arr[10] = {5, 3, 8, 6, 0, 1, 2, 9, 4, 7};

	int i;
	for (i=0; i < sizeof(global_array)/sizeof(global_array[0]); i++)
	{
		global_array[i] = rand();
	}

	printf("Init array\n");
	for (i=0; i < sizeof(tmp_arr)/sizeof(tmp_arr[0]); i++)
	{
		printf("| %d |", tmp_arr[i]);
	}
	printf("\n");

	//BubbleSort(tmp_arr, sizeof(tmp_arr)/sizeof(tmp_arr[0]));
	BubbleSort(global_array, sizeof(global_array)/sizeof(global_array[0]));

	printf("Final array\n");
	for (i=0; i < sizeof(tmp_arr)/sizeof(tmp_arr[0]); i++)
	{
		printf("| %d |", tmp_arr[i]);
	}
	printf("\n");

	return 0;
}

