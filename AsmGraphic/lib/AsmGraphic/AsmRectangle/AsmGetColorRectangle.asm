section .data

section .text
    global AsmGetColorRectangle
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmGetColorRectangle:
    xor rax, rax
    mov eax, dword[rdi + 20]
    bswap eax
    ret