TITLE Project 6 - String Primitives and Macros Parameters     (Proj6_cheshirj.asm)

; Author: John Cheshire
; Last Modified: March 6, 2021
; OSU email address: cheshirj@oregonstate.edu
; Course number/section:   CS271 Section 401
; Project Number: 6                Due Date: March 14, 2021
; Description:	This program reads in 10 integers as strings, converts the strings to SDWORDS,
;				displays the numbers, calculates the average, and calculates the sum of the numbers.
;				It then reads in 10 floats as strings, converts them to floating point numbers,
;				displays the numbers, calculates the average, and calculates the sum of the numbers.

INCLUDE Irvine32.inc

; Constants
	SDWORD_LENGTH	= 12				; Number of digits in an SDWORD type plus space for null and sign
	REAL4_LENGTH	= 50				; Max digits and decimal point in REAL4 (1.4E-45) plus space for null and sign

.data
	intro				BYTE	"Project 6 - String Primitives and Macros -- by John Cheshire",13,10,13,10,0
	extraCredit			BYTE	"**EC: Each line asking for input is numbered and the running total sum is displayed",13,10,0
						BYTE	"**EC: ReadFloatVal and WriteFloatVal are implemented to handle floating point numbers",13,10,13,10,0
	instructionsInt		BYTE	"Please enter ten signed decimal integers.",13,10
						BYTE	"Numbers must be between 2,147,483,647 and -2,147,483,648 (inclusive).",13,10
						BYTE	"Additionally, the sum of the numbers must also be between those numbers.",13,10,13,10
						BYTE	"The program will display the numbers, their sum, and their average.",13,10,13,10,0
	sdwordString		BYTE	SDWORD_LENGTH DUP(0)
	real4String			BYTE	REAL4_LENGTH DUP(0)
	bytesRead			DWORD	0
	readValueInt		SDWORD	0
	readValueFloat		REAL4	0.0
	enterPromptInt		BYTE	"Please enter a signed interger: ",0
	enterPromptReal		BYTE	"Please enter a floating point number: ",0
	errorPrompt			BYTE	"You didn't enter a number in the proper format or it was too large!",13,10
						BYTE	"Please try again: ",0
	textEnterVals		BYTE	"You entered these numbers:",13,10,0
	textSum				BYTE	"The sum of the values is: ",0
	textAvg				BYTE	"The average of the values is: ",0
	goodBye				BYTE	"Thanks for trying the program, have a great day!!",13,10,0


.code
main				PROC

	

	Invoke ExitProcess, 0				; exit to operating system
main				ENDP
	MOV		EDX, OFFSET intro
	CALL	WriteString

;--------------------------------------------------------------------------------------------------------------
; Name: 
;
; Description: 
;
; Preconditions:
;
; Postconditions: 
;
; Receives:
;			[EBP + 8]	=	
;
; Returns: Nothing
;
;--------------------------------------------------------------------------------------------------------------

END main
