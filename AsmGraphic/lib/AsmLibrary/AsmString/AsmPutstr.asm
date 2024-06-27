section .data

section .text
    global AsmPutstr
    %include "AsmLibrary.inc"

AsmPutstr:
    cmp rdi, 0
    je .bye
    mov rsi, rdi
    mov rdx, -1
    .loop:
        inc rdx
        cmp byte[rsi + rdx], 0
        jne .loop
    mov rax, 1
    mov rdi, 1
    syscall
    .bye:
    ret
