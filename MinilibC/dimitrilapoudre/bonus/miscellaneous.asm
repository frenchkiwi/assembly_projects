section .data

section .text
    global atoi

atoi:
    mov r8, 1
    mov r9, 0
    mov rax, 0
    mov rcx, -1
    .loop_getnbr:
        cmp rax, 2147483647
        jg .zero_getnbr
        cmp rax, -2147483648
        jl .zero_getnbr
        inc rcx
        cmp byte [rdi + rcx], 45
        je .neg_getnbr
        cmp byte [rdi + rcx], 43
        je .pos_getnbr
        cmp byte [rdi + rcx], 48
        jl .bye_getnbr
        cmp byte [rdi + rcx], 57
        jg .bye_getnbr
        
        mov r9, 1
        mov rdx, 10
        mul rdx

        movzx rbx, byte [rdi + rcx]
        sub bl, 48
        add rax, rbx
        jmp .loop_getnbr

    .zero_getnbr:
        mov rax, 0
        ret

    .pos_getnbr:
        cmp r9, 0
        jne .bye_getnbr
        jmp .loop_getnbr

    .neg_getnbr:
        cmp r9, 0
        jne .bye_getnbr
        neg r8
        jmp .loop_getnbr

    .bye_getnbr:
        cmp r8, 1
        je .bye_getnbr2
        neg rax
        .bye_getnbr2:
            ret
