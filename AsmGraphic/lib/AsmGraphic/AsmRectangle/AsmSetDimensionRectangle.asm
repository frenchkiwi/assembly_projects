section .data

section .text
    global AsmSetDimensionRectangle
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmSetDimensionRectangle:
    cmp rdi, 0
    je .bye_error
    
    mov qword[rdi], rsi

    xor rax, rax
    ret

    .bye_error:
        mov rax, -1
        ret