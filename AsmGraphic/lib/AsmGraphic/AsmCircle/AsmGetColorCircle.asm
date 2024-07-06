section .data

section .text
    global AsmGetColorCircle
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmGetColorCircle:
    xor rax, rax
    mov eax, dword[rdi + 20]
    bswap eax
    ret