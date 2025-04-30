section .data

section .text
    global AsmStrrchr
    %include "AsmLibrary.inc"

AsmStrrchr:
    mov rax, rdi
    xor r8, r8
    .for:
        cmp byte [rax], 0
        je .end
        cmp byte [rax], sil
        je .save
        inc rax
        jmp .for
    .save:
        mov r8, rax
        inc rax
        jmp .for
    .end:
        cmp sil, 0
        je .bye
        mov rax, r8
    .bye:
        ret