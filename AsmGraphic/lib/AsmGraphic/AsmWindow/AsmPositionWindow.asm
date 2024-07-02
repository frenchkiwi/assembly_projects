section .data

section .text
    global AsmPositionWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmPositionWindow:
    xor rax, rax
    mov eax, dword[rdi + 16]
    ret