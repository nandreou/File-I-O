global prints
prints:

push r12

xor rdx, rdx
mov r12, rsi

.check:
cmp [r12], byte 0
je .done 
inc rdx
inc r12
jmp .check

.done:
mov rax, 1
mov rdi, 1
syscall

pop r12
ret