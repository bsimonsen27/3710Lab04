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

cseg
	mov		wdtcn,#0DEh
	mov		wdtcn,#0ADh

	mov			xbr2,#40H		; activate I/O ports