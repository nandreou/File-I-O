extern printf

extern test_FD
extern FD

section .data

part_number db "Part %i:",10,10,0

section .text

global print_part

print_part:

push rbp
mov rbp, rsp

mov rax, 0
mov rdi, part_number
mov rsi, rbx
call printf

mov rsp, rbp
pop rbp
ret
