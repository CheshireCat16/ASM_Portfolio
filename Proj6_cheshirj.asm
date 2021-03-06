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

;--------------------------------------------------------------------------------------------------------------
; Name: mGetString
;
; Description:	Shows the user a prompt and then reads in a string of up to the specified size while storing the
;				number of bytes read in the specified variable.
;
; Preconditions:
;
; Postconditions: None
;
; Receives:
;			prompt			= Address of string to display to user as prompt
;			inputLocaiton	= Address of array of bytes to store read-in string
;			strMax			= Maximun number of characters to read
;			charRead		= Address of variable to store number of characters read
;
; Returns:
;			inputLocation	= Updated with read-in string
;			charRead		= Number of characters read from input
;
;--------------------------------------------------------------------------------------------------------------
mGetString		MACRO	prompt:REQ, inputLocation:REQ, strMax:REQ, charRead:REQ
	; Move changed registers onto the stack
	PUSH		EAX
	PUSH		ECX
	PUSH		EDX

	; Display the promopt
	MOV			EDX, prompt
	CALL		WriteString

	; Read in the user's input
	MOV			EDX, inputLocation
	MOV			ECX, strMax
	CALL		ReadString

	; Record number of bytes read
	MOV			[charRead], EAX

	; Restores the modified registers
	POP			EDX
	POP			ECX
	POP			EAX
ENDM

;--------------------------------------------------------------------------------------------------------------
; Name: mDisplayString
;
; Description: Displays a string to the console
;
; Preconditions: None
;
; Postconditions: None
;
; Receives:
;			displayStr	= Address of a string to display
;
; Returns: Nothing
;
;--------------------------------------------------------------------------------------------------------------
mDisplayString		MACRO	displayStr:REQ
	; Move changed registers onto the stack
	PUSH		EDX

	; Display the string
	MOV			EDX, displayStr
	CALL		WriteString

	; Restores the modified registers
	POP			EDX
ENDM

; Constants
	SDWORD_LENGTH	= 11				; Number of digits in an SDWORD type plus space for sign
	REAL4_LENGTH	= 49				; Max digits and decimal point in REAL4 (1.4E-45) plus space for sign
	MAX_READ		= REAL4_LENGTH + 2  ; Max number of digits to read, gives space for null and extra for detecting long input

.data
	intro				BYTE	"Project 6 - String Primitives and Macros -- by John Cheshire",13,10,13,10,0
	extraCredit			BYTE	"**EC: Each line asking for input is numbered",13,10,"and the running total sum is displayed",13,10
						BYTE	"**EC: ReadFloatVal and WriteFloatVal are implemented,",13,10,"to handle floating point numbers",13,10,13,10,0
	instructionsInt		BYTE	"Please enter ten signed decimal integers.",13,10
						BYTE	"Numbers must be between 2,147,483,647 and -2,147,483,648 (inclusive).",13,10
						BYTE	"Additionally, the sum of the numbers must also be between those numbers.",13,10,13,10
						BYTE	"The program will display the numbers, their sum, and their average.",13,10,13,10,0
	sdwordString		BYTE	MAX_READ DUP(0)
	real4String			BYTE	MAX_READ DUP(0)
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
	
	; Display the program introduction
	MOV		EDX, OFFSET intro
	CALL	WriteString

	; Display extra credit lines
	MOV		EDX, OFFSET extraCredit
	CALL	WriteString

	; Test getting a string
	mGetString OFFSET enterPromptInt, OFFSET sdwordString, MAX_READ, OFFSET bytesRead

	; Test writing a string
	mDisplayString OFFSET sdwordString

	Invoke ExitProcess, 0				; exit to operating system
main				ENDP


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
ReadVal		PROC

	RET
ReadVal		ENDP


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
WriteVal		PROC

	RET
WriteVal		ENDP

END main
