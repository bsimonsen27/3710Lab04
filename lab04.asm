;==========================================================
; Program Name: lab04.asm
;
;	Authors: Paul Runov & Brendon Simonsen
;
; Description:
; This program will simulate a magic 8-ball. It will wait
; for input from either the buttons or the a character from
; the serial port. After receiving an input, a random LED 
;	will be displayed that corresponds with a response from
; the magic 8-ball. A corresponding message will be sent
; via the serial port 
;
; Company:
;	Weber State University 
;
; Date			Version		Description
; ----			-------		-----------
; 2/18/2024	V1.0			Initial description
;==========================================================

$include (c8051f020.inc)

	; declaring variables
dseg at 30h
	pos:	ds 1				; stores the position for the LED

org	0
	mov wdtcn,#0DEh 	; disable watchdog
	mov	wdtcn,#0ADh
	mov	xbr2,#40h			; enable port output
	mov	xbr0,#04h			; enable uart 0
	mov	oscxcn,#67H		; turn on external crystal
	mov	tmod,#20H			; wait 1ms using T1 mode 2
	mov	th1,#256-167	; 2MHz clock, 167 counts = 1ms
	setb	tr1

wait1:
	jnb	tf1,wait1
	clr	tr1						; 1ms has elapsed, stop timer
	clr	tf1
wait2:

	mov	a,oscxcn			; now wait for crystal to stabilize
	jnb	acc.7,wait2
	mov	oscicn,#8			; engage! Now using 22.1184MHz

	mov	scon0,#50H		; 8-bit, variable baud, receive enable
	mov	th1,#-6				; 9600 baud
	setb	tr1					; start baud clock

msg_1:DB "It is certain", 0DH, 0AH, 0
msg_2:DB "You may rely on it", 0DH, 0AH, 0
msg_3:DB "Without a doubt", 0DH, 0AH,0
msg_4:DB "Yes", 0DH, 0AH, 0
msg_5:DB "Most Likely", 0DH, 0AH, 0
msg_6:DB "Reply hazy, try again", 0DH, 0AH, 0
msg_7:DB "Concentrate and ask again", 0DH, 0AH, 0
msg_8:DB "Very Doubtful", 0DH, 0AH, 0
msg_9:DB "My reply is no", 0DH, 0AH, 0
;--------------------------------------------------------------------
;MAIN
		
		;DESCRIPTION
		;This is the main routine that controls the flow of the program
;--------------------------------------------------------------------
		


end:
		jmp end

;--------------------------------------------------------------------
;10 ms delay
		
		;DESCRIPTION
		;This is the routine that has a 10 ms delay
;--------------------------------------------------------------------

delay:


MOV TMOD, #01H      ; Set Timer 0 in mode 1 (16-bit mode)
    MOV TH0, #0FCH      ; Load the high byte of the initial value (0xFC)
    MOV TL0, #066H      ; Load the low byte of the initial value (0x66)

START_TIMER:
    SETB TR0            ; Start Timer 0
WAIT_FOR_OVERFLOW:
    JNB TF0, WAIT_FOR_OVERFLOW ; Wait for the overflow flag (TF0) to be set
    CLR TF0             ; Clear the overflow flag
    ; At this point, approximately 1 ms has elapsed.
    ; Add your code here to do whatever needs to be done after 1 ms
    SJMP START_TIMER    ; Loop back to start the timer again for another delay

		

;--------------------------------------------------------------------
;SEND_STRING

		;DESCRIPTION
		;This subrouting sends a whole string through the serial port 
;--------------------------------------------------------------------

send_str:

		clr C
		movc	A, @A + dptr
		jz		done			; finish this
		call	send_char
		inc 	dptr
		jmp		send_str:		


;--------------------------------------------------------------------
;SEND CHARACTER 

;  DESCRIPTION
;	 This subroutine will take the string, and send it sends it via the serial port.  
;--------------------------------------------------------------------

send_char: 		;send a value in the acc to the serial port

		mov SBUF0, A

wait:
		JNB	TI, wait
		clr TI
		ret

;-------------------------------------------------------
;CHECK_BUTTON
;
; DESCRIPTION:
; Checks if the buttons have been pressed. Has code to 
; protect against the button being held down. 
;
;-------------------------------------------------------
chk_btn:	mov A,P2
					cpl A
					xch	A, old_btn
					xrl A, old_btn
					anl A, old_btn
					ret

; Check if the RI flag is 1?
;--------------------------------------------------------------------
;RANDOM

		;DESCRIPTION
		;This subroutine will take the timer and 

;-------------------------------------------------------------------

random:
		call delay
		djnz random, continue
		mov  random. #10
		ret 

continue
		call check_buttons.

;------------------------------------------------------------------
;DISPLAY_LED
;
; DESCRIPTION:
;	This subroutine will take the random value stored in the 'pos'
; variable and displays that LED
;
;--------------------------------------------------------------------

; Display led's
disp_led: mov p3, #0FFh 			;turn LED's off
					orl p2, #003h				;turn LED's off

					mov a, pos 					;	check if 0
					cjne a, #1, not_one	; junp if 0
					clr p3.0						; turn on LED 1
					ret									; return to an end game state

not_one: cjne a,#2,not_two		; compare if pos (which is in accum) is 1
					clr p3.1						; turn on LED 2
					ret									; return to an end game state

not_two:  cjne a,#3,not_three	; compare if pos is 2
					clr p3.2						; turn on LED 3
					ret									; return to an end game state

not_three:cjne a,#4,not_four	; compare if pos is 3
					clr p3.3						; turn on LED 4
					ret									; return to an end game state

not_four:cjne a,#5,not_five		; compare if pos is 4
					clr p3.4						; turn on LED 5
					ret									; return to an end game state
		
not_five: cjne a,#6,not_six		; compare if pos is 5
					clr p3.5						; turn on LED 6
					ret									; return to an end game state

not_six: cjne a,#7,not_seven		; compare if pos is 6
					clr p3.6						; turn on LED 7
					ret									; return to an end game state

not_seven:cjne a,#8,not_eight	; compare if pos is 7
					clr p3.7						; turn on LED 8
					ret									; return to an end game state

not_eight:cjne a,#9,not_nine	; compare if pos is 8
					clr p2.0						; turn on LED 9
					ret									; return to an end game state

not_nine:	clr p2.1						; turn on LED 10
					ret									; return to an end game state

end