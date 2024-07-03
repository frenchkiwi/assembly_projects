section .data

section .text
    global AsmMemmove
    %include "AsmLibrary.inc"

AsmMemmove:
    cmp rdx, 0
    je .bye
    mov r8, rdx
    neg r8
    and r8, -8
    neg r8
    sub rsp, r8
    mov rcx, 0
    .copy:
        mov r9b, byte[rsi + rcx]
        mov byte[rsp + rcx], r9b
        inc rcx
        cmp rcx, rdx
        jne .copy
    mov rcx, 0
    .paste:
        mov r9b, byte[rsp + rcx]
        mov byte[rdi + rcx], r9b
        inc rcx
        cmp rcx, rdx
        jne .paste
    add rsp, r8
    .bye:
    ret