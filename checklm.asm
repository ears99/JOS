;checks to see if the processor is 64-bit or not.
checklm: ;check long mode
	pusha
	
	pushfd
	pop eax
	mov ecx, eax
	
	;flip the ID bit
	xor eax, 1 << 21 ;if the 21st bit of eax is different than 1, flip it to one. 

	push eax
	popfd

	pushfd
	pop eax

	xor eax, ecx
	;return true if they're different 
	jz .done

	mov eax, 0x80000000 ;if cpuid pulls out a value, anything greater than this value + 1, we can read extended information
	cpuid
	cmp eax, 0x80000001
	jb .done ;jump if eax is less than 0x80000001, meaning we can't support long mode. else we can get extended info through cpuid

	mov eax, 0x80000001 ;gets extended processor info
	cpuid
	test edx, 1 << 29 ;see if the 29th bit is equal to 1. 
	jz .done ;if the 29th bit is equal to zero, jump to done; long mode isn't supported.

	mov si, YES_LM
	call print_str
	popa ;else pop all off the stack
	ret ;exit subroutine



	.done:
		popa
		mov si, NO_LM
		call print_str
		jmp $
