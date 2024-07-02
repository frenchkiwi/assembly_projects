section .data

section .text
    global AsmSizeWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmSizeWindow:
    xor rax, rax
    mov eax, dword[rdi + 20]
    ret