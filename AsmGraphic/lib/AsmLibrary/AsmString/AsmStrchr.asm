section .data

section .text
    global AsmStrchr
    %include "AsmLibrary.inc"

AsmStrchr:
    dec rdi
    .loop:
        inc rdi
        cmp byte[rdi], sil
        je .return_here
        cmp byte[rdi], 0
        jne .loop
    xor rax, rax
    ret

    .return_here:
        mov rax, rdi
        ret