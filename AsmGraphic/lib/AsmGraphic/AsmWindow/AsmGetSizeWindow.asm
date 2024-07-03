section .data

section .text
    global AsmGetSizeWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmGetSizeWindow:
    xor rax, rax
    mov eax, dword[rdi + 20]
    ret