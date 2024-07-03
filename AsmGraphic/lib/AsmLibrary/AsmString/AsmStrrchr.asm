section .data

section .text
    global AsmStrrchr
    %include "AsmLibrary.inc"

AsmStrrchr:
    dec rdi
    xor rax, rax
    .loop:
        inc rdi
        cmp byte[rdi], sil
        cmove rax, rdi
        cmp byte[rdi], 0
        jne .loop
    ret