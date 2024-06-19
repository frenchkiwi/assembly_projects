section .text
    global AsmPower
    %include "AsmLibrary.inc"

AsmPower:
    cmp rsi, 0
    jl .neg

    mov rax, 1
    cmp rsi, 0
    je .bye
    .loop:
        dec rsi

        mul rdi

        cmp rsi, 0
        jne .loop
    .bye:
    ret

    .neg:
        mov rax, 0
        ret