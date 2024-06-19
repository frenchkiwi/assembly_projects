section .data

section .text
    global AsmIsNum
    %include "AsmLibrary.inc"

AsmIsNum:
    xor rax, rax
    cmp rdi, 0
    je .bye
    xor r8, r8
    mov rcx, -1
    mov r9, 1
    .loop:
        inc rcx
        cmp byte[rdi + rcx], 0
        cmove rax, r9
        je .bye
        cmp byte[rdi + rcx], '-'
        je .sign
        cmp byte[rdi + rcx], '+'
        je .sign
        cmp byte[rdi + rcx], '0'
        jl .bye
        cmp byte[rdi + rcx], '9'
        jg .bye
        jmp .loop

        .sign:
            cmp r8, 0
            jne .bye
            mov r8, 1
            jmp .loop
    .bye:
    ret
