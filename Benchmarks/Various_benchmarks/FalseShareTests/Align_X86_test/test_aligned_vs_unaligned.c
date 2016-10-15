#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>
#include <unistd.h>

#define DATASIZE 1000000000
uint32_t        stampstart();
uint32_t        stampstop(uint32_t start);
void            Munge32(void *data, uint32_t size);
void            Munge64(void *data, uint32_t size);
 
#ifndef MUNGE64
#define MUNGE Munge32
#else
#define MUNGE Munge64
#endif
 
int
main(int argc, char **argv)
{
 
	uint32_t        align;
	uint8_t        *data;
	uint32_t        start;
	uint8_t        *unaligned_data __attribute__ ((aligned(2)));
	uint8_t        *aligned_data8 __attribute__ ((aligned(8)));
	uint8_t        *aligned_data16 __attribute__ ((aligned(16)));
	uint8_t        *aligned_data32 __attribute__ ((aligned(32)));
/* 
	if (argc != 2)
	  {
		  printf("usage : %s alignment\n", argv[0]);
		  exit(-1);
	  }
*/
	//align = atoi(argv[1]);

int i = 0;
align = 0;
while(align < 4)
{
for (i = 0; i < 10; i++)
{
 
	switch (align)
	  {
	  //case 8:
	  case 0:
		  printf("\nData aligned at 8 bits\n");
		  start = stampstart();
		  aligned_data8 = malloc(DATASIZE);
		  MUNGE(aligned_data8, DATASIZE);
		  free(aligned_data8);
		  stampstop(start);
		  break;
 
	  //case 16:
	  case 1:
		  printf("\nData aligned at 16 bits\n");
		  start = stampstart();
		  aligned_data16 = malloc(DATASIZE);
		  MUNGE(aligned_data16, DATASIZE);
		  free(aligned_data16);
		  stampstop(start);
		  break;
 
	  //case 32:
	  case 2:
		  printf("\nData aligned at 32 bits\n");
		  start = stampstart();
		  aligned_data32 = malloc(DATASIZE);
		  MUNGE(aligned_data32, DATASIZE);
		  free(aligned_data32);
		  stampstop(start);
		  break;
 
	  default:		/* Unalign data */
		  printf("\nData unaligned \n");
		  start = stampstart();
		  unaligned_data = malloc(DATASIZE);
		  MUNGE(unaligned_data, DATASIZE);
		  free(unaligned_data);
		  stampstop(start);
	  }
 
}
align++;
} 
	return 0;
 
}
 
void
Munge64(void *data, uint32_t size)
{
 
	double         *data64 = (double *) data;
	double         *data64End = data64 + (size >> 3);	/* Divide size by 8. */
	uint8_t        *data8 = (uint8_t *) data64End;
	uint8_t        *data8End = data8 + (size & 0x00000007);	/* Strip upper 29 bits. */
 
	printf("Using 64bit blocks\n");
 
	while (data64 != data64End)
	  {
		  *data64++ = -*data64;
	  }
	while (data8 != data8End)
	  {
		  *data8++ = -*data8;
	  }
}
 
void
Munge32(void *data, uint32_t size)
{
 
	uint32_t       *data32 = (uint32_t *) data;
	uint32_t       *data32End = data32 + (size >> 2);	/* Divide size by 4. */
	uint8_t        *data8 = (uint8_t *) data32End;
	uint8_t        *data8End = data8 + (size & 0x00000003);	/* Strip upper 30 bits. */
 
	printf("Using 32bit blocks\n");
 
	while (data32 != data32End)
	  {
		  *data32++ = -*data32;
	  }
	while (data8 != data8End)
	  {
		  *data8++ = -*data8;
	  }
}
 
uint32_t
stampstart()
{
	struct timeval  tv;
	struct timezone tz;
	struct tm      *tm;
	uint32_t        start;
 
	gettimeofday(&tv, &tz);
	tm = localtime(&tv.tv_sec);
 
	printf("TIMESTAMP-START\t  %d:%02d:%02d:%d (~%d ms)\n", tm->tm_hour,
	       tm->tm_min, tm->tm_sec, tv.tv_usec,
	       tm->tm_hour * 3600 * 1000 + tm->tm_min * 60 * 1000 +
	       tm->tm_sec * 1000 + tv.tv_usec / 1000);
 
	start = tm->tm_hour * 3600 * 1000 + tm->tm_min * 60 * 1000 +
		tm->tm_sec * 1000 + tv.tv_usec / 1000;
 
	return (start);
 
}
 
uint32_t
stampstop(uint32_t start)
{
 
	struct timeval  tv;
	struct timezone tz;
	struct tm      *tm;
	uint32_t        stop;
 
	gettimeofday(&tv, &tz);
	tm = localtime(&tv.tv_sec);
 
	stop = tm->tm_hour * 3600 * 1000 + tm->tm_min * 60 * 1000 +
		tm->tm_sec * 1000 + tv.tv_usec / 1000;
 
	printf("TIMESTAMP-END\t  %d:%02d:%02d:%d (~%d ms) \n", tm->tm_hour,
	       tm->tm_min, tm->tm_sec, tv.tv_usec,
	       tm->tm_hour * 3600 * 1000 + tm->tm_min * 60 * 1000 +
	       tm->tm_sec * 1000 + tv.tv_usec / 1000);
 
	printf("ELAPSED\t  %d ms\n", stop - start);
 
	return (stop);
 
}
