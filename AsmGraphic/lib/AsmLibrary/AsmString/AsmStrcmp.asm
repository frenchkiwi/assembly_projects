section .data

section .text
    global AsmStrcmp
    %include "AsmLibrary.inc"

AsmStrcmp:
    mov rcx, -1
    .loop:
        inc rcx
        mov r8b, byte[rsi + rcx]
        cmp byte[rdi + rcx], r8b
        jne .not_equal
        cmp byte[rdi + rcx], 0
        jne .loop
    xor rax, rax
    ret
    .not_equal:
        movzx rax, byte[rdi + rcx]
        movzx rdx, byte[rsi + rcx]
        sub rax, rdx
        ret

