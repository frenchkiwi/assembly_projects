section .data

section .text
    global AsmPutlstr
    %include "AsmLibrary.inc"

AsmPutlstr:
    cmp rdi, 0
    je .bye
    mov rsi, rdi
    mov rdx, -1
    .loop:
        inc rdx
        cmp byte[rsi + rdx], 0
        jne .loop
    inc rdx
    mov rax, 1
    mov rdi, 1
    syscall
    mov rdi, 10
    call AsmPutchar
    .bye:
    ret

