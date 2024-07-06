section .data

section .text
    global AsmGetDimensionRectangle
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmGetDimensionRectangle:
    mov rax, qword[rdi]
    ret