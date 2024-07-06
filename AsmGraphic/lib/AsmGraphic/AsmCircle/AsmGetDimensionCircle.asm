section .data

section .text
    global AsmGetDimensionCircle
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmGetDimensionCircle:
    mov rax, qword[rdi]
    ret