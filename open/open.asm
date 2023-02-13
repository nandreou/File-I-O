extern prints
extern NR_open

global open_file_append
global open_file_write_read

section .data
;creation status flags
O_CREAT equ 00000100q
O_APPEND equ 00002000q

;access mode
O_RDONLY equ 000000
O_WRONLY equ 000001
O_RDWR equ 000002


error_append db "Error on appending read-write- append file",10,0
error_open db "Error on opening read-write file",10,0
succes_open db "succes on open read-write file",10,0
succes_append db "succes on open read-write-append file",10,0

section .text

open_file_write_read:

mov rax, NR_open
mov rsi, O_RDWR
syscall

cmp rax, 0
jl .error_open

.success_open:
push rax

mov rsi, succes_open
call prints

pop rax
ret

.error_open:

push rax

mov rsi, error_open
call prints

pop rax

ret
;--------------------------------------------------------------------

open_file_append:

mov rax, NR_open
mov rsi, O_APPEND |O_RDWR
syscall

cmp rax, 0
jl .error_append

.success_append:

push rax

mov rsi, succes_append 
call prints

pop rax
ret

.error_append:
mov rsi, error_append
call prints

pop rax
ret