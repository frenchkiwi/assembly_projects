section .data

section .text
    global AsmGetAngleCircle
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmGetAngleCircle:
    xor rax, rax
    mov eax, dword[rdi + 24]
    ret