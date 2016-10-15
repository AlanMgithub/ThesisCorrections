/*
 *         ARM - Embedded Coding Assignment 
 *        
 *              Author: Alan Mujumdar
 *		
 *                   Name: Header
 *
 * Code presented in this file is written from scratch.
 *
*/

// Guards
#ifndef SEND_MSG_INCLUDED 
#define SEND_MSG_INCLUDED

// Function prototype
void sendMsg(char address, char data[], int length);
#ifdef TEST_SENDMSG
void setDebugStatusRegMode (int mode);
#endif

#endif
