section .data

section .text
    global AsmHasMovedWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmHasMovedWindow:
    xor rax, rax
    cmp rdi, 0
    je .bye

    mov r8b, byte[rdi + 25]
    or r8b, 1
    cmp byte[rdi + 25], r8b
    jne .bye

    mov rax, 1

    .bye:
    ret