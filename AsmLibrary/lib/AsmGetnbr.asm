section .data

section .text
    global AsmGetnbr
    %include "AsmLibrary.inc"

AsmGetnbr:
    xor rax, rax
    cmp rdi, 0
    je .bye
    xor r9, r9
    mov rcx, -1
    mov r8, 10
    .loop:
        inc rcx
        cmp byte[rdi + rcx], '-'
        je .sign
        cmp byte[rdi + rcx], '+'
        je .sign
        cmp byte[rdi + rcx], '0'
        jl .bye
        cmp byte[rdi + rcx], '9'
        jg .bye
        
        mul r8
        movzx r10, byte[rdi + rcx]
        sub r10, '0'
        add rax, r10
        jmp .loop

        .sign:
            cmp r9, 0
            jne .bye
            movzx r9, byte[rdi + rcx]
            jmp .loop
    .bye:
    cmp r9, '-'
    jne .return
    neg rax
    .return:
    ret