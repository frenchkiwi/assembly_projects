%include "my_macro.asm"

section .data

section .text
    extern my_putnbr
    global _start

_start:
    CALL_ my_putnbr, 123
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
