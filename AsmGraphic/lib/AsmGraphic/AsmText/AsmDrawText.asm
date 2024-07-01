section .data

section .text
    global AsmDrawText
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmDrawText:
    cmp rdi, 0
    je .bye_error0
    cmp dword[rdi + 4], 0
    je .bye
    cmp rsi, 0
    je .bye_error0

    push rbx
    push r12
    push r13
    push r14
    push r15



    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    .bye
    xor rax, rax
    ret

    .bye_error0:
        mov rax, -1
        ret