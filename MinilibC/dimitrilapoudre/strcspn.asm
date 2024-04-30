section .data

section .text
    global strcspn

strcspn:
    mov rax, -1
    .loop_strlen:
        inc rax
        mov rcx, -1
        .loop_strchr:
            inc rcx
            cmp byte [rsi + rcx], sil
            je .bye
            cmp byte [rsi + rcx], 0
            jne .loop_strchr
        cmp byte [rdi + rax], 0
        jne .loop_strlen
    .bye:
    ret
