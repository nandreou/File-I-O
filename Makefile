bin=file

f1=./print/print_FD.o 
f2=./print/prints.o 
f3= ./print/print_part.o
r_asm=./open/open.asm
r_o= ./open/open.o

${bin}: file.o ${f1} $(f2) ${f3} ${r_o}
	clang -o ${bin} $^ -no-pie

file.o: file.asm
	nasm -f elf64 -g -F dwarf $^

${f1}: ./print/print_FD.asm
	nasm -f elf64 -g -F dwarf $^

${f2}: ./print/prints.asm
	nasm -f elf64 -g -F dwarf $^

${f3}: ./print/print_part.asm
	nasm -f elf64 -g -F dwarf $^

${r_o}: ${r_asm}
	nasm -f elf64 -g -F dwarf $^

clear:
	rm ${f1} ${f2} ${f3} ${r_o} file.o file testfile.txt
