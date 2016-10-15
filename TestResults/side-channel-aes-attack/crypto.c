/*  
*   Byte-oriented AES-256 implementation.
*   All lookup tables replaced with 'on the fly' calculations. 
*
*   Copyright (c) 2007 Ilya O. Levin, http://www.literatecode.com
*
*   Permission to use, copy, modify, and distribute this software for any
*   purpose with or without fee is hereby granted, provided that the above
*   copyright notice and this permission notice appear in all copies.
*
*   THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
*   WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
*   MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
*   ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
*   WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
*   ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
*   OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/
#include <stdlib.h>
#include <stdio.h>
//#include "aes256.h"
#include "aes256.c"

#define DUMP(s, i, buf, sz)  {printf(s);                   \
                              for (i = 0; i < (sz);i++)    \
                                  printf("%02x ", buf[i]); \
                              printf("\n");}

#define BUF_SIZE 16 
#define CONST 2

int main (int argc, char *argv[])
{
    int c;
    int key_var = 0;

    aes256_context ctx; 
    uint8_t key[32];
    uint8_t buf[BUF_SIZE], i, j;

    struct timespec tstart={0,0}, tend={0,0};

    extern char *optarg;
    while ((c = getopt(argc, argv, "k:stoh")) != -1)
    {
	switch (c)
	{
	  case 'k': key_var = atoi(optarg);
		break;
	}
    }

    // Fill text to encrypt
    for (i = 0; i < BUF_SIZE;i++) {
      buf[i] = i;
    }
 
    // Display Plain Text
    DUMP("Text: ", i, buf, sizeof(buf));

    // Fill key value
    for (i = 0; i < sizeof(key);i++) {
          key[i] = i;
    }

    // Display selected key
    DUMP("key: ", i, key, sizeof(key));

    // INIT AES
    aes256_init(&ctx, key);
    // RUN ENCRYPTION & GET TIME
    clock_gettime(CLOCK_MONOTONIC, &tstart);
    aes256_encrypt_ecb(&ctx, buf);
    clock_gettime(CLOCK_MONOTONIC, &tend);

    // Display Plain Text
    DUMP("Encrypted: ", i, buf, sizeof(buf));

    // FINISH 
    aes256_done(&ctx);
 
    // PRINT ENCRYPTION RESULTS
    printf("Encryption took %.16f seconds to complete\n",
        	((double)tend.tv_sec + 1.0e-9*tend.tv_nsec) - 
        	((double)tstart.tv_sec + 1.0e-9*tstart.tv_nsec));

    return 0;
}

