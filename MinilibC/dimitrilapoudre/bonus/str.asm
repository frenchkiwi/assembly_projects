section .data

section .text
    global strcpy
    global strncpy
    global strcat
    global strncat

strcpy:
    mov rcx, -1
    .loop_strcpy:
        inc rcx
        mov r8b, byte [rsi + rcx]
        mov byte [rdi + rcx], r8b
        cmp byte [rsi + rcx], 0
        jne .loop_strcpy
    mov rax, rdi
    ret

strncpy:
    mov rcx, -1
    .loop_strncpy:
        inc rcx
        cmp rdx, rcx
        je .bye_strncpy
        mov r8b, byte [rsi + rcx]
        mov byte [rdi + rcx], r8b
        cmp byte [rsi + rcx], 0
        jne .loop_strncpy
    .bye_strncpy:
        mov rax, rdi
        ret
strcat:
    mov rcx, -1
    .loop_destlen_strcat:
        inc rcx
        cmp byte [rdi + rcx], 0
        jne .loop_destlen_strcat
    mov rdx, -1
    .loop_strcat:
        inc rdx
        mov r8b, byte [rsi + rdx]
        add rcx, rdx
        mov byte [rdi + rcx], r8b
        sub rcx, rdx
        cmp byte [rsi + rdx], 0
        jne .loop_strcat
    mov rax, rdi
    ret

strncat:
    mov r9, rdx
    mov rcx, -1
    .loop_destlen_strncat:
        inc rcx
        cmp byte [rdi + rcx], 0
        jne .loop_destlen_strncat
    mov rdx, -1
    .loop_strncat:
        inc rdx
        cmp rdx, r9
        je .bye_strncat
        cmp byte [rsi + rdx], 0
        je .bye_strncat
        mov r8b, byte [rsi + rdx]
        add rcx, rdx
        mov byte [rdi + rcx], r8b
        sub rcx, rdx
        jmp .loop_strncat
    .bye_strncat:
        add rcx, rdx
        mov byte [rdi + rcx], 0
        mov rax, rdi
        ret
