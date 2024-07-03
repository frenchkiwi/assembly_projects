section .data

section .text
    global AsmStrcpy
    %include "AsmLibrary.inc"

AsmStrcpy:
    mov rcx, -1
    .loop:
        inc rcx
        mov r8b, byte[rsi + rcx]
        mov byte[rdi + rcx], r8b
        cmp byte[rsi + rcx], 0
        jne .loop
    mov rax, rdi
    ret