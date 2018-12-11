;test the A20 line - if we can enable it (assuming it's off by default) then we get access to all the memory on offer to us. 
; We're not trying to write an OS that's compatible with 8086 hardware, so we need it enabled. 

testA20:
	pusha
;set up a reference so we have something to test from. 
	mov ax, [0x7DFE]
	mov dx, ax
	call print_hex

;set up segment register
	push bx 
	mov bx, 0xFFFF
	mov es, bx ;set segment register es to zero.
	pop bx

	mov bx, 0x7E0E ;where the magic number should be located in memory
	mov dx, [es:bx] ;if the A20 line is enabled, we should get some garbage data. if disabled, we should get 0xAA55.
	call print_hex
	cmp ax, dx ;compare the segment and reference

	je .cont ;if the segment and reference are equal, go to .cont
	popa ;else, pop all of the stack
	mov ax, 1 ;signal that the reference and segment aren't equal
	ret

	;2nd test to check if the A20 line is disabled
	.cont: ;testing to make sure that it wasn't a fluke - this is proper practice to test the A20 line! Twice is the reccomendation

		;set reference (& everything else) to one bit over to compare them again. 
		mov ax, [0x7DFF] ;instead of 0x7DFE
		mov dx, ax
		call print_hex
		push bx
		mov bx, 0xFFFF
		mov es, bx
		pop bx

		mov bx, 0x7E0F
		mov dx, [es:bx]
		call print_hex

		cmp ax, dx  ;compare them again
		je .exit ;if they're equal, exit
		popa  ;else pop all off the stack...
		mov ax, 1 ;...and set ax to one. 
		ret
		
		.exit: ;else, exit the subroutine
		popa
		xor ax, ax
		ret

;darn...we have to use algebra in real life! :(
;FORMULA FOR SEGMENTATION: S * 16 + O, where S = the segment, and O is the offset
;0xFFFF x 16 = 0xFFFF0 
;O is the unknown...
;0xFFFF0 + O = 0x107DFE 
;O = 0x107DFE - 0xFFFF0
;O = 0x7E0E

