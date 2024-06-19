section .data

section .text
    global AsmCalloc
    %include "AsmLibrary.inc"

AsmCalloc:
    push rdi
    push rsi
    call AsmAlloc
    pop rsi
    pop rdi
    cmp rax, 0
    je .bye
    xor rcx, rcx
    .loop:
        mov byte [rax + rcx], sil
        inc rcx
        cmp rcx, rdi
        jne .loop
    .bye:
    ret