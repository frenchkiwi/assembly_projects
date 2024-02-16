%include "my_macro.asm"

section .data

section .text
    extern my_putnbr
    global _start

_start:
    pop rdi ; get ac
    cmp rdi, 1 ; check if its a cat void
    jle cat_void ; go to cat void if yes
    CALL_ my_putnbr, rdi
    jmp _exit

cat_void:
    mov rax, 12
    mov rdi, 0
    syscall
    mov r8, rax

    mov rax, 12
    lea rdi, [r8 + 30000]
    syscall ; malloc char buffer[30000]
    
    .loop:
        mov rax, 0
        mov rdi, 0
        mov rsi, r8
        mov rdx, 29999
        syscall ; read the stdin

        cmp rax, 0
        je _exit ; check if exit

        mov rdx, rax
        mov rax, 1
        mov rdi, 1
        mov rsi, r8
        syscall ; print the buffer
        jmp .loop ; go again forever

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

_error:
    mov rax, 60
    mov rdi, 84
    syscall
