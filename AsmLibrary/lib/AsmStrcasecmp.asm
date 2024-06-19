section .data

section .text
    global AsmStrcasecmp
    %include "AsmLibrary.inc"

AsmStrcasecmp:
    mov rcx, -1
    .loop:
        inc rcx
        movzx r8, byte[rdi + rcx]
        .check_case:
            cmp r8, 'A'
            jl .leave_check_case
            cmp r8, 'Z'
            jg .leave_check_case
            add r8, 32
        .leave_check_case:
        movzx r9, byte[rsi + rcx]
        .check_case2:
            cmp r9, 'A'
            jl .leave_check_case2
            cmp r9, 'Z'
            jg .leave_check_case2
            add r9, 32
        .leave_check_case2:
        cmp r8, r9
        jne .not_equal
        cmp r8, 0
        jne .loop
    xor rax, rax
    ret
    .not_equal:
        mov rax, r8
        sub rax, r9 
        ret