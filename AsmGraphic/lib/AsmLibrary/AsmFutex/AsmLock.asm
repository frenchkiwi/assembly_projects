section .data

section .text
    global AsmLock
    %include "AsmLibrary.inc"

AsmLock:
    mov rax, 1
    xchg byte[rdi], al
    cmp rax, 0
    je .bye
    .loop:
        mov rax, 2
        xchg byte[rdi], al
        cmp rax, 0
        je .bye
        mov rax, 202
        mov rdi, rdi
        mov rsi, 0
        mov rdx, 2
        mov r10, 0
        mov r8, 0
        syscall
        jmp .loop
    .bye:
        ret
