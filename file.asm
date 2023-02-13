extern create_file
extern print_FD
extern prints
extern print_part
extern open_file_append
extern open_file_write_read

global test_FD 
global FD
global NR_open

section .data

;CONDITIONAL

CREATE equ 1
OVERWRITE equ 1
APPEND equ 1
O_WRITE equ 1
READ equ 1
O_READ equ 1
DELETE equ 1

; syscall numbers

NR_read equ 0
NR_write equ 1
NR_open equ 2
NR_close equ 3
NR_lseek equ 8
NR_create equ 85
NR_unlink equ 87

;create_mode (permissions)
S_IRUSR equ 00400q ;user read permission
S_IWUSR equ 00200q ;user write permission

bufferlen equ 64

test_FD db "The FD is: %i",10,0 
filename db "testfile.txt",0
FD dq 0 ;file descriptor

text1 db "1. Hello World",10,0
len1 dq $-text1-1
text2 db "2. Iam comming for you jobs",10,0
len2 dq $-text2-1
text3 db "3. Alive and kicking!!",10,0
len3 dq $-text3-1
text4 db "4. Adios de chatGPT ",10,0
len4 dq $-text4-1

error_create db "Error on Creating file",10,0
error_close db "Error on closing file",10,0
error_read db "Error on reading file",10,0
error_write db "Error on writing file",10,0
error_delete db "Error on deleting file",10,0
error_print db "Error on printing file",10,0
error_position db "Error on positioning file",10,0

create_success db "succes on Creating file",10,0
write_success db "succes on writng file",10,0
close_success db "succes on closing file",10,10,0
read_success db "succes on reading file",10,0
succes_delete db "succes on deleting file",10,0
succes_pos db "succes on setting offset file",10,0

section .bss

buffer resb bufferlen

section .text

global main

main:

push rbp
mov rbp,rsp

mov rbx, 1

call print_part
inc rbx

;{Part1} >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Create, write, close.

;Call create file
mov rdi, filename
call create_file
mov [FD], rax

;Call write file
mov rdi, [FD]
mov rsi, text1
mov rdx, [len1]
call write_file

;Call close file
mov rdi, [FD]
call close_file

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< END

call print_part
inc rbx

;{Part2} >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> open, overwrite, close.

;Open file
mov rdi, filename
call open_file_write_read
mov [FD], rax

;Overwrite file
mov rdi, [FD]
mov rsi, text2
mov rdx, [len2]
call write_file

;Close
mov rdi, [FD]
call close_file

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< END

call print_part
inc rbx

;{Part3} >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> open, append, close.

;open_append
mov rdi, filename
call open_file_append
mov [FD], rax

;write
mov rdi, [FD]
mov rsi, text4
mov rdx, [len2]
call write_file

;close file
mov rdi, [FD]
call close_file

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< END

call print_part
inc rbx

;{Part4} >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> open, off_set_overwrite, close.

;Open file
mov rdi, filename
call open_file_write_read
mov [FD], rax

;position

push r12 ;callee saved
mov r12, [len2] ;offset calibration 
add r12, 5 ;offset calibration

mov rdi, [FD]
mov rsi, r12
mov rdx, 0
call positioning

pop r12

mov rdi, [FD]
mov rsi, text3
mov rdx, [len3]
call write_file

mov rdi, [FD]
call close_file
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< END

call print_part
inc rbx

;{Part5} >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> open, off_set_append, close.

;open file
mov rdi, filename
call open_file_write_read
mov [FD], rax

;read file
mov rdi, [FD]
mov rsi, buffer
mov rdx, bufferlen
call read_file

;close file
mov rdi, [FD]
call close_file

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< END

;{Part6} >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> open, off_set_append, close.

;open file

mov rdi, filename
call open_file_write_read
mov [FD], rax

;positioning

xor r12, r12
mov r12, [len2] ;offset calibrate
add r12, 5 ;offset calibrate

mov rdi, [FD]
mov rsi, r12
mov rdx, 0
call positioning

;read file

mov rdi, [FD]
mov rsi, buffer
mov rdx, bufferlen
call read_file

mov rdi, [FD]
call close_file
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< END

;Call delete file
;mov rdi, filename
;call delete_file

mov rsp,rbp
pop rbp
ret

;--------------------------------------------------------------------

create_file:

mov rax, NR_create
mov rsi, S_IRUSR |S_IWUSR
syscall

cmp rax, 0
jl .err_create

push rax

.succ_create:
mov rsi, create_success
call prints

pop rax
ret

.err_create:
mov rsi, error_create
call prints
ret

;--------------------------------------------------------------------

close_file:

mov rax, NR_close
syscall

cmp rax, 0
jl .err_close

.succ_close:
mov rsi, close_success
call prints
ret

.err_close:
mov rsi, error_close
call prints
ret

;--------------------------------------------------------------------

write_file:

mov rax, NR_write
syscall

cmp rax, 0
jl .error_write

.sucess_write:

mov rsi, write_success
call prints
ret

.error_write:

mov rdi, error_write
call prints
ret

;--------------------------------------------------------------------

positioning:

mov rax, NR_lseek
syscall

cmp rax, 0
jl .error_position

.succes_position:

mov rsi, succes_pos
call prints
ret

.error_position:

mov rsi, error_position
call prints
ret

;--------------------------------------------------------------------

read_file:

mov rax, NR_read
syscall

cmp rax, 0
jl .error_read

.read_success:
push rax

mov rsi, read_success
call prints

pop rax

mov rsi, buffer

mov [rsi+rax], byte 10
inc rax
mov [rsi+rax], byte 0
call prints

ret

.error_read:
mov rsi, error_read
call prints

ret
;--------------------------------------------------------------------

delete_file:

mov rax, NR_unlink
syscall

cmp rax, 0
jl .delete_error

.delete_success:

mov rsi, succes_delete
call prints

mov rsp,rbp
pop rbp
ret

.delete_error:
mov rsi, error_delete
call prints

ret

