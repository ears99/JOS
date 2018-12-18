#JOS Makefile
ASM = nasm -fbin main.asm
OUT = -o main.bin
RM = rm main.bin

main.bin: main.asm read_disk.asm print_str.asm print_hex.asm testA20.asm enableA20.asm checklm.asm
	$(ASM) $(OUT)
clean: 
	$(RM)
run:
	qemu-system-x86_64 main.bin
