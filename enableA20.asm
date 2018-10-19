;ALL THREE WORK SUCCESSFULLY, 9 times out of 10, BIOS will work, but it's good to test multiple times just to make sure. 
enableA20:
pusha
	;BIOS A20 ENABLE
	mov ax, 0x2401 ;high bit is 24, low bit is 01. value for enabling the A20 line.
	int 0x15 ;BIOS interrupt for the A20 line
	call testA20
	cmp ax, 1 ;ax returns 1 if A20 is enabled
	je .done ;if they're equal, go to .done
	ret ;else, exit subroutine

	;KEYBOARD CONTROLLER A20 ENABLE
	;keyboard command port: 0x64
	;keyboard data port: 0x60

	;disable keyboard and interrupts
	sti
	call wait_c ;wait for the controller to accept a command
	mov al, 0xAD ;disable the keyboard
	out 0x64, al ;sends data to port 0x64
	call wait_c

	;read from keyboard
	call wait_c ;wait for the command port to not be busy.
	mov al, 0xD0
	out 0x64, al  ;tell the computer we want to read from the keyboard
	
	call wait_d ;wait for the data port to not by busy
	in al, 0x60 ;when data port is ready, read data into register al from port 0x60
	push ax ;save that value for later. 
 
	call wait_c
	mov al, 0xD1 ;we're sending it data
	out 0x64, al

	call wait_c
	pop ax
	or al, 2 ;mask the second bit
	out 0x60, al ;send it out through the data port

	
	;re-enable the keyboard
	call wait_c
	mov al, 0xAE ;re-enable the keyboard
	out 0x64, al 

	call wait_c
	sti ;reinstate interrupts

	call testA20
	cmp al, 1
	je .done
	ret


;FAST A20 ENABLE -
;communicates with the chipset, uses port 0x92
;don't have to wait for any command ports or data ports; it's just ready

	in al, 0x92
	or al, 2 ;mask bit 2
	out 0x92, al
	call testA20
	cmp al, 1
	je .done ;jump to .done if it's equal, enabling the A20 line.

	mov si, NO_A20	;else print out the NO_A20 message to the screen
	call print_str
	jmp $

.done: 
	popa ;pop all off the stack
	mov ax, 1 ;exit value
	ret ;exit subroutine

wait_c:
;wait for the command port to not be busy
	in al, 0x64 ;takes in data from keyboard through a port and stores it in a register
	test al, 2  ;test the second bit - if the 2nd bit is 1, it's busy, if 0, it's busy. 
	jnz wait_c  ;jump to wait_c if it's not equal to zero.
	ret

wait_d:
;wait for the data port to not be busy
	in al, 0x64
	test al, 1 ;test first bit in al - if data is ready, return 0. else, return 1
	jz wait_d
	ret



