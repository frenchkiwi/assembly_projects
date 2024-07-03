section .data

section .text
    global AsmStrncmp
    %include "AsmLibrary.inc"

AsmStrncmp:
    mov rcx, -1
    .loop:
        inc rcx
        cmp rdx, rcx
        je .bye
        mov r8b, byte[rsi + rcx]
        cmp byte[rdi + rcx], r8b
        jne .not_equal
        cmp byte[rdi + rcx], 0
        jne .loop
    .bye:
    xor rax, rax
    ret
    .not_equal:
        movzx rax, byte[rdi + rcx]
        movzx rdx, byte[rsi + rcx]
        sub rax, rdx
        ret
