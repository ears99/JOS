read_disk:
	pusha
	mov ah, 0x02 ;read sectors from hard drive
	mov dl, 0x80 ;boot from HDD = 0x80. 0x00 = RM (removable media).
	mov cl, 0 ;select first cylinder
	mov dh, 0 ;first head
	mov al, 1 ;only read one sector
	mov cl, 2 ;start reading second sector

	;load 512 bytes after 0x7C00
	;we can't set the segment registers directly.
	;so move the segment register to zero indirectly by using bx. 
	
	push bx
	mov bx, 0
	mov es, bx
	pop bx
	mov bx, 0x7C00 + 512 ;load us 512 bytes after 0x7C00, 0x7E00.

	int 0x13 ;BIOS int for reading disk

	jc disk_error ;if CF is set, jump to disk_error
	popa ;else pop all registers off the stack
	ret ;exit read_disk subroutine
disk_error:
	mov si, DISK_ERR_MSG
	call print_str
	jmp $ ;hang at current memory location
