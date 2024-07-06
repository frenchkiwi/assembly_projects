section .data

section .text
    global AsmGetColorText
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmGetColorText:
    xor rax, rax
    mov eax, dword[rdi + 24]
    bswap eax
    ret