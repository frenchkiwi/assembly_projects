section .data

section .text
    global strchr

strchr:
    mov rcx, -1
    .loop_strchr:
        inc rcx
        cmp byte [rdi + rcx], sil
        je .finded
        cmp byte [rdi + rcx], 0
        jne .loop_strchr
    mov rax, 0
    ret

    .finded:
        mov rax, rdi
        add rax, rcx
        ret
