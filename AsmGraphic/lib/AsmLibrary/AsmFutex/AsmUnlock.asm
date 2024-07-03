section .data

section .text
    global AsmUnlock
    %include "AsmLibrary.inc"

AsmUnlock:
    mov rax, -1
    lock xadd byte[rdi], al
    cmp rax, 1
    je .bye
    mov rax, 0
    xchg byte[rdi], al
    mov rax, 202
    mov rdi, rdi
    mov rsi, 1
    mov rdx, 1
    mov r10, 0
    mov r8, 0
    syscall
    .bye:
        ret
