section .data

section .text
    global AsmMemset
    %include "AsmLibrary.inc"

AsmMemset:
    cmp rdx, 0
    je .bye
    mov rcx, 0
    .loop:
        mov byte[rdi + rcx], sil
        inc rcx
        cmp rcx, rdx
        jne .loop
    .bye:
    mov rax, rdi
    ret