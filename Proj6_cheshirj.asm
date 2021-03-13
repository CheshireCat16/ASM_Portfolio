TITLE Project 6 - String Primitives and Macros Parameters     (Proj6_cheshirj.asm)

; Author: John Cheshire
; Last Modified: March 6, 2021
; OSU email address: cheshirj@oregonstate.edu
; Course number/section:   CS271 Section 401
; Project Number: 6                Due Date: March 14, 2021
; Description:	This program reads in 10 integers as strings, converts the strings to SDWORDS,
;				displays the numbers, calculates the average, and calculates the sum of the numbers.


INCLUDE Irvine32.inc

;--------------------------------------------------------------------------------------------------------------
; Name: mGetString
;
; Description:	Shows the user a prompt and then reads in a string of up to the specified size while storing the
;				number of bytes read in the specified variable.
;
; Preconditions: EAX, ECX, and EDX should not be used as parameters
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
	VALUE_COUNT		= 10				; The number of values to read in

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
	readValueInt		SDWORD	VALUE_COUNT DUP(0)
	readValueFloat		REAL4	VALUE_COUNT DUP(0.0)
	bytesRead			DWORD	0
	enterPromptInt		BYTE	"Please enter a signed interger: ",0
	enterPromptReal		BYTE	"Please enter a floating point number: ",0
	errorPrompt			BYTE	"You didn't enter a number in the proper format or it was too large!",13,10
						BYTE	"Please try again: ",0
	textEnterVals		BYTE	"You entered these numbers: ",0
	commaSpace			BYTE	", ",0
	textSum				BYTE	"The sum of the values is: ",0
	textAvg				BYTE	"The average of the values is: ",0
	goodBye				BYTE	"Thanks for trying the program, have a great day!!",13,10,0


.code
main				PROC
	;-------------------------------------------------------------------
	; Display program introduction, extra credit lines,
	; and explain how the program works.
	;-------------------------------------------------------------------
	; Display the program introduction
	MOV				EDX, OFFSET intro
	CALL			WriteString

	; Display extra credit lines
;	MOV				EDX, OFFSET extraCredit
;	CALL			WriteString

	; Display the program instructions
	MOV				EDX, OFFSET instructionsInt
	CALL			WriteString

	;-------------------------------------------------------------------
	; This section of the program goes through a loop to read in 
	; the required number of values.
	;-------------------------------------------------------------------
	; Set up counter for loop for reading Int values and beginning of array of SDWORDS
	MOV				ECX, VALUE_COUNT
	MOV				EDI, OFFSET readValueInt

	; Loop for reading in intger values
_readInts:
	; Put required variables for calling ReadVal on the stack and call ReadVal
	PUSH			EDI
	PUSH			OFFSET enterPromptInt
	PUSH			OFFSET errorPrompt
	PUSH			OFFSET MAX_READ
	PUSH			OFFSET bytesRead
	CALL			ReadVal

	; Move to the next value in the array of integer
	ADD				EDI, 4
	LOOP			_readInts

	; Add a new line to improve output formatting
	CALL			CrLf


	;-------------------------------------------------------------------
	; This section of the program goes through a loop to write 
	; out the values that were read in.
	;-------------------------------------------------------------------
	; Prepare for writine out values
	MOV				ECX, VALUE_COUNT
	MOV				ESI, OFFSET readValueInt

	; Display the text that introduces the integer
	MOV				EDX, OFFSET textEnterVals
	CALL			WriteString

	; Loop for writing out integers
_showInts:	
	; Put interger to show on stack and write it out
	PUSH			[ESI]
	CALL			WriteVal

	; Write a comma and space, except for last item
	CMP				ECX, 1
	JE				_noComma
	MOV				EDX, OFFSET commaSpace
	CALL			WriteString

	; Jump here on the last item to skip putting a comma
_noComma:
	; Move to the next value and loop
	ADD				ESI, 4
	LOOP			_showInts

	; After showing the integer, a new line is needed
	CALL			CrLf

	;-------------------------------------------------------------------
	; This section of the program calculates the sum of the numbers
	; and the average of the numbers and then displays them.
	;-------------------------------------------------------------------
	; Clear EAX for use as an accumulator
	XOR				EAX, EAX

	; Set up ESI to read in the ints and ECX to count
	MOV				ESI, OFFSET readValueInt
	MOV				ECX, VALUE_COUNT

	; Add up integers to get sum
_addAnotherInt:
	ADD				EAX, [ESI]
	ADD				ESI, TYPE SDWORD
	LOOP			_addAnotherInt

	; Show the text string for the sum
	MOV				EDX, OFFSET textSum
	CALL			WriteString
	PUSH			EAX
	CALL			WriteVal
	CALL			CrLf

	; Calculate the average
	MOV				EBX, VALUE_COUNT
	CDQ
	IDIV			EBX

	; Show the text string for the average
	MOV				EDX, OFFSET textAvg
	CALL			WriteString
	PUSH			EAX
	CALL			WriteVal
	CALL			CrLf
	CALL			CrLf

	; Say goodbye
	MOV				EDX, OFFSET goodBye
	CALL			WriteString

	Invoke ExitProcess, 0				; exit to operating system
main				ENDP


;--------------------------------------------------------------------------------------------------------------
; Name: ReadVal
;
; Description:	Reads in console input, validates that the input is not too long to be an SDWORD
;				and that the input is a valid number. Also accepts +/- signs. If number is not
;				valid, user will be prompted to try entering a number again.
;
; Preconditions: None
;
; Postconditions: Values at [EBP + 8] may be modified
;
; Receives:
;			[EBP + 8]	=	Number of bytes read
;			[EBP + 12]	=	Maximum number of bytes to read
;			[EBP + 16]	=	Prompt to display when an error is detected
;			[EBP + 20]	=	Basic prompt for an integer
;			[EBP + 24]	=	Adddress of variable to store SDWORD
;
; Returns:
;			[EBP + 24]	=	Entered string as an SDWORD 
;
;--------------------------------------------------------------------------------------------------------------
ReadVal		PROC
	; Set up stack base pointer and preseve modified registers
	LOCAL		inputString:	DWORD			; Offest of location for read in string on stack
	LOCAL		finalMult:		SDWORD			; Multiplier to make value positive or negative
	LOCAL		maxBytes:		DWORD			; Max bytes to read for valid input
	LOCAL		currentValue:	DWORD			; Holds the currently read value from the string
	PUSH		EDI
	PUSH		EDX
	PUSH		ESI
	PUSH		ECX
	PUSH		EAX
	PUSH		EBX

	; Move ESP down by max number of bytes to read and store in top in inputString and make sure direction flag is set
	SUB			ESP, [EBP + 12]
	MOV			inputString, ESP
	CLD

	; Default to a multiplier of 1 (positive) and max bytes without a sign
	MOV			finalMult, 1
	MOV			maxBytes, 10

	; Make sure the passed SDWORD variable is empty
	MOV			EDI, [EBP + 24]
	MOV			EBX, 0
	MOV			[EDI], EBX

	; Prompt user and read in string
	mGetString	[EBP + 20], inputString, [EBP + 12], [EBP + 8]

	; Jump here to test new input after finding invalid input
_startAgain:

	; Set up the counter for number of values to read
	MOV			ECX, [EBP + 8]

	; Load the first value
	MOV			ESI, inputString
	XOR			EAX, EAX			; Clears EAX before writing a byte
	LODSB

	; Check if the first value in the string is a +
	CMP			EAX, 43
	JNE			_notPlus
	LODSB
	DEC			ECX
	INC			maxBytes			; One valid byte is taken up by the sign
	JMP			_checkLength
	
	; Check if the first value in the string is a - and set to finalMult to -1 to make value negative at end
_notPlus:
	CMP			EAX, 45
	JNE			_checkLength
	MOV			finalMult, -1
	INC			maxBytes			; One valid byte is taken up by the sign
	LODSB
	DEC			ECX

	; Check that the input string was not too long
_checkLength:
	PUSH		EAX
	MOV			EAX, [EBP + 8]
	CMP			EAX, maxBytes
	POP			EAX
	JG			_invalid

	; Loop through all input values, validating each one
_mainLoop:
	; Checks if the current value is less than a 0 in ASCII
	CMP			EAX, 48
	JL			_invalid
	; Checks if the current value is greater than 9 in ASCII
	CMP			EAX, 57
	JG			_invalid

	; Reduce EAX by 48 to make 0 ASCII into 0 int
	SUB			EAX, 48

	; Multiply [EBP + 24] by 10 and add the new value
	MOV			EBX, 10
	MOV			currentValue, EAX
	MOV			EAX, [EDI]
	MUL			EBX
	; Make sure the carry flag has not been set when we add
	JC			_invalid
	MOV			[EDI], EAX
	MOV			EAX, currentValue
	ADD			[EDI], EAX
	; Make sure the carry flag has not been set when we multiply
	JC			_invalid


	; Move to next value
	LODSB
	LOOP		_mainLoop

	; Check whether the value is too great for a positive or negative SDWORD
	MOV			EBX, 2147483648
	CMP			EBX, [EDI]
	JB			_invalid
	JE			_checkNegative
	JMP			_sizeCheckPassed

	; Check if the value is negative, if it's not the number entered was too large
_checkNegative:
	CMP			finalMult, -1
	JNE			_invalid

	; Jumping here after checking the number is less or equal to than 2^31 - 1 and greater than or equal to -2^31
_sizeCheckPassed:

	; Multiply by finalMult to get correct sign
	MOV			EAX, [EDI]
	MUL			finalMult
	MOV			[EDI], EAX

	; Ensure the invalid logic is skipped if string successfully read in
	JMP			_endOfProc



	; Handles the case of an invalid input with a new prompt
_invalid:
	; Default to a multiplier of 1 (positive) and max bytes without a sign
	MOV			finalMult, 1
	MOV			maxBytes, 10

	; Make sure the passed SDWORD variable is empty
	MOV			EDI, [EBP + 24]
	MOV			EBX, 0
	MOV			[EDI], EBX

	; Prompt user with error message and read in string
	mGetString	[EBP + 16], inputString, [EBP + 12], [EBP + 8]
	JMP			_startAgain

	; Jump when procedure finishes successfully
_endOfProc:
	

	; Restore modified registers
	ADD			ESP, [EBP + 12]
	POP			EBX
	POP			EAX
	POP			ECX
	POP			ESI
	POP			EDX
	POP			EDI
	RET			20
ReadVal		ENDP


;--------------------------------------------------------------------------------------------------------------
; Name: WriteVal
;
; Description: Writes out the passed SDWORD to the console
;
; Preconditions: Passed value is an SDWORD
;
; Postconditions: None
;
; Receives:
;			[EBP + 8]	=	SDWORD to write out as a string
;
; Returns: Nothing
;
;--------------------------------------------------------------------------------------------------------------
WriteVal		PROC
	; Set up local variables and preseve modified registers
	LOCAL		outputString: DWORD			; Offest of location for string to display on the stack
	LOCAL		negativeSign: DWORD			; Tracks whether to include a negative sign at the front of the string
	SUB			ESP, 12						; Make room for a string of up to 10 numbers, plus sign, plus null
	MOV			outputString, ESP
	PUSH		EAX
	PUSH		EDI
	PUSH		EBX

	; We'll move down the string from bottom (high mem address) to top (low mem address) so set direction flag
	STD

	; Load the end of the string into EDI and add a null
	MOV			EBX, outputString
	ADD			EBX, 11
	MOV			EDI, EBX
	XOR			EAX, EAX
	STOSB		

	;	Get the value read for reading to a string
	MOV			EAX, [EBP + 8]

	; Check if it's negative
	CMP			EAX, 0
	JGE			_notNegative
	
	; Make positive and set negative flag
	MOV			EBX, -1
	MUL			EBX
	MOV			negativeSign, 45			; Move in the ASCII character for a negative sign
	JMP			_convertToString

	; Jump here if the entered value was positive
_notNegative:
	; Set negativeSign to 0 so it will be skipped
	MOV			negativeSign, 0

	; Add values to string until all values are read
_convertToString:
	; Divide the current value by 10 to get the remainder
	MOV			EBX, 10
	XOR			EDX, EDX
	DIV			EBX
	;	Move the remainder into the string
	PUSH		EAX
	MOV			EAX, EDX
	ADD			EAX, 48			; Add 48 to make 0 into ASCII 0
	STOSB
	POP			EAX

	; Check if the quotient is 0, if so, that's the end of the number
	CMP			EAX, 0
	JNE			_convertToString

	; Check if the value was negative and add negative sign if needed
	CMP			negativeSign, 45
	JNE			_noNegSign
	MOV			EAX, negativeSign
	STOSB

_noNegSign:
	; ESI should point to one higher than the output string, a
	MOV			outputString, EDI
	ADD			outputString, 1

	; Display the string
	mDisplayString	outputString
	
	; Restore modified registers and clean up manually set local variables
	POP			EBX
	POP			EDI
	POP			EAX
	ADD			ESP, 12
	RET			4
WriteVal		ENDP

END main
