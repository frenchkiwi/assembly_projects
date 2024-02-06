section .rodata
    newline db 10, 0

section .text
    extern my_strlen
    extern my_strcat
    extern my_putstr
    global _start

concat_params:
    mov rcx, 1
    mov rdx, 0
    loop_concat_params_len:
        inc rcx
        mov rdi, 0
        mov rdi, [rsp + 8 * rcx]
        cmp rdi, 0
        je bye_concat_params_len
        call my_strlen
        add rdx, rax
        inc rdx
        jmp loop_concat_params_len
    bye_concat_params_len:
    mov rax, 12
    mov rdi, 0
    syscall
    mov r8, rax
    
    add rax, rdx
    inc rax
    lea rdi, [r9 + rax]
    mov rax, 12
    syscall

    mov rcx, 1
    loop_concat_params:
        inc rcx
        mov rsi, 0
        mov rsi, [rsp + 8 * rcx]
        cmp rsi, 0
        je bye_concat_params
        cmp rcx, 2
        jg newline_concat_params
        return_newline_concat_params:
        mov rdi, r8
        push rcx
        push r8
        call my_strcat
        pop r8
        pop rcx
        jmp loop_concat_params
    bye_concat_params:
    mov rax, r8
    ret

    newline_concat_params:
        push rcx
        push r8
        push rsi
        mov rdi, r8
        mov rsi, newline
        call my_strcat
        pop rsi
        pop r8
        pop rcx
        jmp return_newline_concat_params

_start:
    call concat_params
    mov rdi, rax
    call my_putstr
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
