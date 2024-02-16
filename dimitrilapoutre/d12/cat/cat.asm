%include "my_macro.asm"

section .data
    error_msg db "cat: ", 0
    error_not db ": No such file or directory", 10, 0
    error_acc db ": Permission denied", 10, 0
    error_dir db ": Is a directory", 10, 0

section .bss
    buffer resb 30000

section .text
    extern my_putnbr
    extern my_putchar
    extern my_putcharerror
    extern my_putstr
    extern my_puterror
    global _start

_start:
    mov r9, 0

    pop r10 ; get ac
    cmp r10, 1 ; check if its a cat void
    jle cat_void ; go to cat void if yes

    pop rdi
    .loop:
        dec r10
        cmp r10, 0
        je _exit ; check if end

        pop rdi ; get param
        mov rax, 2
        mov rsi, 0
        mov rdx, 0
        syscall ; open(param, O_RDONLY)

        cmp rax, 0
        jl .error ; check if error with open

        mov r12, rax
        CALL_ my_putnbr, r12
        .loop2:
            mov rdi, r12 ; set fd with open return
            mov rax, 0 ; read()
            mov rsi, buffer ; buffer
            mov rdx, 29999 ; size
            syscall ; read the file

            push rax
            mov rdx, rax
            mov rax, 1
            mov rdi, 1
            mov rsi, buffer
            syscall ; print the buffer
            pop rax

            cmp rax, 29999
            je .loop2 ; check if exit
        mov rax, 3
        mov rdi, r12
        syscall
        jmp .loop
    jmp _exit
    .error:
        mov r12, rax
        CALL_ my_puterror, error_msg
        CALL_ my_puterror, rdi
        mov r9, 84
        cmp r12, -13
        je .acc
        cmp r12, -2
        je .not
        cmp r12, -21
        je .dir
        jmp .loop
        .acc:
            CALL_ my_puterror, error_acc
            jmp .loop
        .dir:
            CALL_ my_puterror, error_dir
            jmp .loop
        .not:
            CALL_ my_puterror, error_not
            jmp .loop

cat_void:
    .loop:
        mov rax, 0
        mov rdi, 0
        mov rsi, buffer
        mov rdx, 29999
        syscall ; read the stdin

        cmp rax, 0
        je _exit ; check if exit

        mov rdx, rax
        mov rax, 1
        mov rdi, 1
        mov rsi, buffer
        syscall ; print the buffer
        jmp .loop ; go again forever

_exit:
    mov rax, 60
    mov rdi, r9
    syscall
