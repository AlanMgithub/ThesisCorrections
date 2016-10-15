// Copyright (c) 2008 Alexander Sandler
//  
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//  
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//  
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/gfp.h>
#include <linux/preempt.h>

#define MEM_AREA_SIZE (1 * 1024 * 1024)

#define TEST_INDENT 62
#define TEST_STEP 128
#define TEST_READ 1

unsigned long pages = 0;

int alloc_memory( void )
{
	pages = __get_free_pages( GFP_KERNEL, get_order( MEM_AREA_SIZE ) );

	if (!pages)
		return -1;

	return 0;
}

void free_memory( void )
{
	if (pages)
		free_pages( pages, get_order( MEM_AREA_SIZE ) );
}

unsigned long long do_single_test( unsigned long real_page, 
								   int area_size,
								   int indent, 
								   int step )
{
	volatile unsigned char* page;
	volatile unsigned long temp = 0xdeadfeadfeaddead;
	unsigned long i;

	unsigned long long before = 0;
	unsigned long long after = 0;

	// Doing the indent...
	page = (unsigned char *)(real_page + indent);

	// Doing the actual test...
	rdtscll( before );
	for (i = 0; i < (area_size / step) - 1; i++)
	{
#if (TEST_READ == 1)
		temp = *((unsigned long *)page);
#else
		*((unsigned long *)page) = temp;
#endif
		page += step;
	}
	rdtscll( after );

	return after - before;
}

int do_the_tests( void )
{
	unsigned long long res;

	if (alloc_memory())
	{
		printk( "Failed to allocate memory\n" );
		free_memory();
		return -1;
	}

	res = do_single_test( pages, MEM_AREA_SIZE, TEST_INDENT, TEST_STEP );

	free_memory();

	printk( "Test result is %llu for indent %d and step %d\n", res, TEST_INDENT, TEST_STEP );

	return 0;
}

int align_init( void )
{
	do_the_tests();
	return -EIO;
}

void align_exit( void )
{
}

MODULE_LICENSE( "GPL" );

module_init( align_init );
module_exit( align_exit );
