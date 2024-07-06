section .data

section .text
    global AsmSetDimensionCircle
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmSetDimensionCircle:
    cmp rdi, 0
    je .bye_error
    
    mov qword[rdi], rsi

    xor rax, rax
    ret

    .bye_error:
        mov rax, -1
        ret