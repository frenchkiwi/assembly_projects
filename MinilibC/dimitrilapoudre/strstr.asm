section .data

section .text
    global strstr

strstr:
    mov r8, -1
    .loop_strstrlen:
        inc r8
        cmp byte [rsi + r8], 0
        jne .loop_strstrlen
    mov rdx, -1
    mov rcx, -1
    .loop_strstr:
        inc rdx
        inc rcx
        cmp rcx, r8
        je  .bye_strstr
        mov r9b, byte [rsi + rcx]
        cmp byte [rdi + rdx], r9b
        jne .reset_and_again_strstr
        .again_loop_strstr:
            cmp byte [rdi + rdx], 0
            jne .loop_strstr
    mov rax, 0
    ret

    .reset_and_again_strstr:
        mov rcx, -1
        jmp .again_loop_strstr

    .bye_strstr:
        sub rdx, r8
        lea rax, [rdi + rdx]
        ret
