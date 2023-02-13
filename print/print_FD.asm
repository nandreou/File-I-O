extern printf
global print_FD
extern test_FD
extern FD

print_FD:

push rbp
mov rbp, rsp

mov rax, 0
mov rdi, test_FD
mov rsi, [FD]
call printf

mov rsp, rbp
pop rbp
ret
