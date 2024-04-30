section .data

section .text
    global strrchr

strrchr:
    mov rcx, -1
    .loop_strlen:
        inc rcx
        cmp byte [rdi + rcx], 0
        jne .loop_strlen
    .loop_strrchr:
        dec rcx
        cmp byte [rdi + rcx], sil
        je .finded
        cmp rcx, 0
        jne .loop_strrchr
    mov rax, 0
    ret

    .finded:
        mov rax, rdi
        add rax, rcx
        ret
