section .data

section .text
    global AsmMemmove
    %include "AsmLibrary.inc"

AsmMemmove:
    cmp rdi, rsi
    je .bye
    jl .forward
    .backward:
        cmp rdx, 0
        je .bye
        dec rdx
        mov r8b, byte [rsi + rdx]
        mov [rdi + rdx], r8b
        jmp .backward
    .forward:
        xor rcx, rcx
        .loop:
            cmp rcx, rdx
            je .bye
            mov r8b, byte [rsi + rcx]
            mov [rdi + rcx], r8b
            inc rcx
            jmp .loop
    .bye:
        mov rax, rdi
        ret