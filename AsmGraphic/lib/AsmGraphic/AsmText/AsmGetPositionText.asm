section .data

section .text
    global AsmGetPositionText
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmGetPositionText:
    xor rax, rax
    mov eax, dword[rdi + 20]
    ret