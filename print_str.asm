print_str:
	pusha ;push all registers onto the stack
	str_loop:
		mov ah, 0x0E ;14 in decimal, enable TTY
		mov al, [si] ;move the address of si into al
		cmp al, 0 ;compare al to end of string (0).

		jne print_char ;if al is not equal to zero, jmp to print_char
		popa ;else, pop all registers off the stack...
		ret ;...and exit the print_str subroutine

	print_char:
		mov ah, 0x0E
		int 0x10 ;BIOS video interrupt
		add si, 1 ;move to the next char in the string.
		jmp str_loop

;trying to create an x86 version of this...currently not having a lot of success...
