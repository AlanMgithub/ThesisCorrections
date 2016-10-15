/*
 *           ARM - Embedded Coding Assignment
 *	
 *                Author: Alan Mujumdar
 *
 *                  Name: Test Suite
 *
 * Code presented in this file is written from scratch.
 * This file can be used for testing the *sendMsg* function
 * When setDebugStatusRegMode is assigned anything but 0,
 * a random function is used to simulate the hardware status
 * register. Thus, random ACK and BUSY STATUS flags can be
 * generated to observe correct *sendMsg* transmit operations
 *
 * For testing build with:
 * gcc -Wall -D TEST_SENDMSG testSendMsg.c sendMsgFunction.c -o testSuite
 *
 * For memory mapped hardware build with:
 * gcc -Wall testSendMsg.c sendMsgFunction.c -o testSuite
 *
*/

#include <stdio.h>
#include <stdlib.h>
#include "sendMsgHeader.h"

int main(void) {
	int menuOption = -1; 
	char address = 0;
	int length = 0;
	int burstLength = 0;
	char data[8096];

	// MENU
	while (menuOption != 0) {
		printf("**************** Select Testing Mode *******************\n");
		printf("*\t'1' for single data burst\n");
		printf("*\t'2' for multi data burst\n");
		printf("*\t'3' for single data burst with random status response\n");
		printf("*\t'4' for multi data burst with random status response\n");
		printf("*\t'0' EXIT\n");
		
		printf("* Select Array Size > ");
		scanf("%d", &length);
		printf("* Input Option > ");
		scanf("%d", &menuOption);

		if (menuOption <= 0 || menuOption > 4 || length < 0 || length > 8096) {
			break;
		}

		if (menuOption == 2 || menuOption == 4) {
			printf("* Burst Length > ");
			scanf("%d", &burstLength);
			if (burstLength > length || burstLength <= 0) {
				burstLength = length;
			}
		}

		int i = 0;
		// Init data to a known value
		for(i = 0; i < length; i++) {
			*(data + i) = (char) i;
		} 

                int burst = 0;
		// ifdef used to remove compiler warnings when building
		// for the actual memory mapped hardware device
		#ifdef TEST_SENDMSG
		// Select status register, ideal response, always ACK and
		// never BUSY 
		int statusOption = 1;
                if (menuOption == 3 || menuOption == 4) {
			// Select random status register mode, ACK or BUSY
			// will vary according to rand() response 
			statusOption = 0;
                }
		setDebugStatusRegMode(statusOption);
		#endif

		// Single burst mode
		if (menuOption == 1 || menuOption == 3) {
			// Generate a test address, sendMsg truncates this
			// value into a byte
			address = rand();
			sendMsg(address, data, length);
		}
		// Multi burst mode
		else {
			for (burst = 0; burst < (length/burstLength) + 1; burst++) {
				address = rand();
				// Length is divided into burst chucks
				sendMsg(address, data, burstLength);
				printf("\n"); // New line between bursts
			}
		}
	}

	return 0;
}
