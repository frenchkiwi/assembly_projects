%include "my_macro_abs.inc"

section .data

section .text
    global _start

_start:
    mov rax, -9
    ABS rax
    jmp _exit

_exit:
    mov rdi, 0
    mov rax, 60
    syscall
