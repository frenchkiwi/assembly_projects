section .data

section .text
    global AsmStrstr
    %include "AsmLibrary.inc"

AsmStrstr:
    dec rdi
    movzx r9, byte[rsi]
    .loop:
        inc rdi
        cmp byte[rdi], r9b
        jne .not_find
        mov rcx, -1
        .loop_cmp:
            inc rcx
            cmp byte[rsi + rcx], 0
            cmove rax, rdi
            je .bye
            mov r8b, byte[rsi + rcx]
            cmp byte[rdi + rcx], r8b
            jne .not_find
            cmp byte[rdi + rcx], 0
            jne .loop_cmp
        .not_find:
        cmp byte[rdi], 0
        jne .loop
    xor rax, rax
    .bye:
    ret