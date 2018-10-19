#JOS Makefile
#target: dependencies 
#	code

main.bin: main.asm read_disk.asm print_str.asm print_hex.asm testA20.asm enableA20.asm checklm.asm
	nasm -fbin main.asm -o main.bin

clean: 
	rm main.bin
run:
	qemu-system-x86_64 main.bin
