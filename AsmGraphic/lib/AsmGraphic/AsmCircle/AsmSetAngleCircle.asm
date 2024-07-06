section .data

section .text
    global AsmSetAngleCircle
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmSetAngleCircle:
    cmp rdi, 0
    je .bye_error
    
    mov qword[rdi + 24], rsi

    xor rax, rax
    ret

    .bye_error:
        mov rax, -1
        ret