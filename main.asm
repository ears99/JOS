;JOS (Jacob Operating System) BOOTSECTOR

[org 0x7C00] ;start at memory address 0x7C00, the part of memory where the boot sector is. 
[bits 16]

section .text
global main
main:

;reset segment registers and set stack pointer to entry point
	cli ;clear interrupts
	jmp 0x0000:zero_seg ;insures that BIOS isn't doing any weird segmenting stuff when we load into 0x7C00.
	zero_seg:
		xor ax, ax ;clears the ax register to zero. (same as doing mov ax, 0) saves extra space if you do it with xor. 
		mov ss, ax ;clears the segment registers
		mov ds, ax
		mov es, ax
		mov fs, ax
		mov gs, ax

		mov sp, main 
		cld ;clear direction flag, correcting for legacy BIOSes or for weird BIOSes. Makes sure we read strings the proper way.
		sti ;reinstate interrupts
 
 		;resets the disk
		push ax
		xor ax, ax
		mov dl, 0x80
		int 0x13

		;loads sectors from the disk
		call read_disk 

		;mov ax, 0x2400
		;int 0x15

		call testA20 ;tests to see if the A20 line is disabled or enabled  
		mov dx, ax
		call print_hex

		;if the A20 line is disabled, but supported, enable it through the BIOS interrupt 0x15 (0xF in hex)
		call enableA20

		jmp sTwo ;once A20 is enabled, jump to sector two, and hang at the current memory position.
		jmp $ ;safety hang

		%include "./print_str.asm"
		%include "./read_disk.asm"
		%include "./print_hex.asm"
		%include "./testA20.asm"
		%include "./enableA20.asm"

		DISK_ERR_MSG: db 'Error Loading Disk.', 0xA, 0xD, 0
		TEST_STR: db 'You are in the second sector.', 0xA, 0xD, 0
		NO_A20: db 'No A20 line.', 0xA, 0xD, 0
		YES_LM: db 'Long mode support.', 0xA, 0xD, 0
	
	;padding and magic number
	times 510 - ($-$$) db 0 ;pads the rest of the boot sector (minus the segment of code we've written)
	dw 0xAA55 ;magic number

	sTwo:  
		mov si, TEST_STR
		call print_str

		%include "./checklm.asm"
		call checklm

		jmp $

	

		times 512 db 0 ;extra padding so QEmu doesn't think we've ran out of disk space
