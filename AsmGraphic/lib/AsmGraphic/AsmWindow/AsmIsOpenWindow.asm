section .data

section .text
    global AsmIsOpenWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmIsOpenWindow:
    xor rax, rax
    cmp rdi, 0
    je .bye
    cmp dword[rdi + 4], 0
    je .bye
    mov rax, 1
    .bye:
    ret
