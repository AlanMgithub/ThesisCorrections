/*
 *        ARM - Embedded Coding Assignment 
 *	
 *             Author: Alan Mujumdar
 *
 *          Name: Send Message Function
 *
 * Code presented in this file is written from scratch.
 *  
 * This file contains the *sendMsg* function and other
 * helper functions required for this assignment.
 *
*/

// Header file
#include "sendMsgHeader.h"

// Register bit masks
// CTRL - |31  -  11|    10    |9   -   8|7 - 0|
// CTRL - |Reserved |SEND_ADDR |DATA_LEN |ADDR |
const unsigned int CTRL_MASK_ADDR = 0x000000FF;	     // Preserves ADDR bits
const unsigned int CTRL_MASK_DATA_LEN = 0x00000300;	 // Preserves DATA_LEN bits
const unsigned int CTRL_MASK_SEND_ADDR = 0x00000400; // Preserves SEND_ADDR bits
// DATA - BYTE MASK
const unsigned int DATA_BYTE_MASK = 0x000000FF;		
// STATUS - |31  -  2| 1 |  0  |
// STATUS - |Reserved|ACK|BUSY |
const unsigned int STATUS_MASK_ACK = 0x00000002;  // Preserves the second least significant bits
const unsigned int STATUS_MASK_BUSY = 0x00000001; // Preserves the first least significant bits

// These variables write to the actual hardware
#ifndef TEST_SENDMSG
	// Memory mapped register addresses
	#define CTRL_REG   0xE0001000 // Address as specified in the assignment
	#define DATA_REG   0xE0001004 // Address as specified in the assignment
	#define STATUS_REG 0xE0001008 // Address as specified in the assignment
	// Prevent compiler optimisation to memory mapped registers
	unsigned int volatile *ctrlReg = (unsigned int *) CTRL_REG;	// Read/Write
	unsigned int volatile *dataReg = (unsigned int *) DATA_REG;	// Read/Write
	unsigned int volatile const *statusReg = (unsigned int *) STATUS_REG; // Read Only
// These are test variables for correctness evaluation
#else
	#include <stdio.h> // Required for debugging but not for the hardware
	#include <stdlib.h> // Required for the rand() function used to set *statusReg
	// Test variables
	unsigned int ctrlRegVariable = 0;
	unsigned int dataRegVariable = 0; 
	unsigned int statusRegVariable = 2; // Set ACK=1 and BUSY=0
	unsigned int *ctrlReg = &ctrlRegVariable; // Read/Write
	unsigned int *dataReg = &dataRegVariable; // Read/Write
	unsigned int *statusReg = &statusRegVariable; // Use Read/Write for testing purposes
	int debugStatusFlag = 0; // Variable for changing device status response 
#endif

// Set appropriate bits for the control register
static unsigned int generateCtrl (int startEndFlag, int dataLength, int address) {
	// Set correct CTRL register bits
	unsigned int setCtrl = ((int) address) & CTRL_MASK_ADDR; // Set ADDR bits 
	setCtrl = setCtrl | (CTRL_MASK_DATA_LEN & ((dataLength - 1)<<8)); // Set DATA_LEN
	if (startEndFlag) {
		// If this is the first packet in a burst
		setCtrl = setCtrl | CTRL_MASK_SEND_ADDR; // Set SEND_ADDR
	}
	return setCtrl;	
}

// Set correct bits for the data packet which is sent to the  data register
static unsigned int generateData (int inputByteCount, char * inputData) {
	unsigned int setData = 0;
	// Set correct DATA register bits
	int byteCount = 0;
	for (byteCount = 0; byteCount < sizeof(int); byteCount++) {
		unsigned int nextByte = 0;
		if (byteCount < inputByteCount) {
			// Apply byte mask to avoid issues with signed char's
			nextByte = (*(inputData + byteCount) & DATA_BYTE_MASK);
		}
		// Pack bytes into a 32 bit packet using little-endian
		setData = setData + (nextByte << 8*byteCount);	
	}
	return setData;
}

// For testing and debugging
#ifdef TEST_SENDMSG
// Register Dump
static void debug (unsigned int ctrl, unsigned int data, unsigned int status, int packet, int reqPacket, int lastPacket) {
	// If the device was busy, no data was sent
	if ((status & STATUS_MASK_BUSY)) {
		printf("CTRL-|SEND:-|LEN:-|ADDR:0x--|, ");
		printf("DATA-0x--'--'--'--, ");
	}
	// If the device read the data
	else {
		// Dump CTRL register contents 
		printf("CTRL-|SEND:%1d|LEN:%1d|ADDR:0x%2x|, ", ((ctrl & CTRL_MASK_SEND_ADDR)>>10), (((ctrl & CTRL_MASK_DATA_LEN)>>8)+1), (ctrl & CTRL_MASK_ADDR));
		printf("DATA-0x%2x'%2x'%2x'%2x, ", ((data & 0xFF000000)>>24), ((data & 0x00FF0000)>>16), ((data & 0x0000FF00)>>8), (data & 0x000000FF));
	}
	// Status register dump
	printf("STATUS;|ACK:%d|BUSY:%d|, ", ((status & STATUS_MASK_ACK)>>1), (status & STATUS_MASK_BUSY));
	// Details of the current packet count and byte count
	printf("Pkt:%4d, ReqPkt:%d, LastPktBytes:%d\n", packet, reqPacket, lastPacket);
}

// Special function for a test file to vary the status register
void setDebugStatusRegMode (int mode) {
	if (mode == 0) {
		// Flag for generating a random status reg response
		debugStatusFlag = 0;
	}
	else {
		// Flag for an ideal status reg response, ACK=1, BUSY=0
		debugStatusFlag = 1;
	}
}

static void randomStatusRegister (void) {
	// Generate random status reg response
	*statusReg = rand();
}
#endif

void sendMsg (char address, char data[], int length) {
	// Calculate number of data packets to transmit
	int requiredPacketCount = length / 4; // Total packet bursts
	int requiredPacketLast = length % 4;  // Last burst, includes zero padding

	int packetCount = 0;
	int dataByteCount = 0;
	// Ensure that message length is not zero and the number of packets
	// does not exceed the desired number of data bytes. If length is an
	// odd value then any unused bytes in the final burst are zero padded
	while ((packetCount <= requiredPacketCount) && (length != 0)) {
		if (!(*statusReg & STATUS_MASK_BUSY)) {
			// Save CTRL register, hardware will ignore this if
			// SEND_ADDR field is not set
			int startEndFlag = 0;
			int dataLength = sizeof(int);
			if (packetCount == 0 || packetCount == requiredPacketCount) {
				// Send CTRL register address when a new transaction 
				// begins or when the last burst in a given transaction 
				// has an odd number of bytes
				startEndFlag = 1;
				if (requiredPacketCount == 0 || packetCount == requiredPacketCount) {
					dataLength = requiredPacketLast;
				}
			}
			// Write CTRL register
			*ctrlReg = generateCtrl(startEndFlag, dataLength, address);

			// Save data packet in the DATA register
			char *dataArrayPtr = &data[dataByteCount];
			if (packetCount == requiredPacketCount) {
				// If the last burst contains less than 4 bytes
				dataLength = requiredPacketLast;
			}
			// Write DATA register
			*dataReg = generateData(dataLength, dataArrayPtr);

			// Check transaction success, retransmit otherwise			
			if (*statusReg & STATUS_MASK_ACK) {
				packetCount++;
				dataByteCount+=4;
			}
		}
	
		// For testing and debugging
		#ifdef TEST_SENDMSG
		debug(*ctrlReg, *dataReg, *statusReg, packetCount, requiredPacketCount, requiredPacketLast);
		// Generate status reg response based on global variable
		if (debugStatusFlag) {
			*statusReg = 2;
		}
		else {
			randomStatusRegister();
		}
		#endif

		// If data length is exactly divisible by 4, exit this loop as
		// all data has been sent. Padded last packet is not required 
		if ((packetCount == requiredPacketCount) && (requiredPacketLast == 0)) {
			return;
		}
	}
}
