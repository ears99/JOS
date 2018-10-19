print_hex: 
	mov si, HEX_PATTERN

	mov bx, dx ;make a copy of the dx register, and store it in bx. we can change bx however we want, and it won't change dx.
	shr bx, 12
	mov bx, [bx + HEX_TABLE]
	mov [HEX_PATTERN + 2], bl
	
	mov bx, dx 
	shr bx, 8
	and bx, 0x000F
	mov bx, [bx + HEX_TABLE]
	mov [HEX_PATTERN + 3], bl

	mov bx, dx
	shr bx, 4
	and bx, 0x000F
	mov bx, [bx + HEX_TABLE]
	mov [HEX_PATTERN + 4], bl
	
	mov bx, dx
	and bx, 0x000F
	mov bx, [bx + HEX_TABLE]
	mov [HEX_PATTERN + 5], bl

	call print_str
	ret
	
HEX_PATTERN: db '0x****', 0x0A, 0x0D, 0 ;hexidecimal template.
HEX_TABLE: db '0123456789ABCDEF'
