section .data

section .text
    global AsmHasResizedWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmHasResizedWindow:
    xor rax, rax
    cmp rdi, 0
    je .bye

    mov r8b, byte[rdi + 25]
    or r8b, 2
    cmp byte[rdi + 25], r8b
    jne .bye

    mov rax, 1

    .bye:
    ret