section .data

section .text
    global AsmGetPositionWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmGetPositionWindow:
    xor rax, rax
    mov eax, dword[rdi + 16]
    ret