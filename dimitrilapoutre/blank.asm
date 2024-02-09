section .data

section .text
    global _start

_start:
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
