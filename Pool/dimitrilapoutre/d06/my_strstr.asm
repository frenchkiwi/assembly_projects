section .data
    string db "hello wor world really", 0
    to_find db "world", 0
    test1 db 'G'
section .text
    extern my_putstr
    global _start

my_strstr:
    mov r8, -1
    loop_strstrlen:
        inc r8
        cmp byte [rsi + r8], 0
        jne loop_strstrlen
    mov rdx, -1
    mov rcx, -1
    loop_my_strstr:
        inc rdx
        inc rcx
        cmp rcx, r8
        je  bye_strstr
        mov r9b, byte [rsi + rcx]
        cmp byte [rdi + rdx], r9b
        jne reset_and_again_my_strstr
        again_loop_my_strstr:
            cmp byte [rdi + rdx], 0
            jne loop_my_strstr
    mov rax, 0
    ret

    reset_and_again_my_strstr:
        mov rcx, -1
        jmp again_loop_my_strstr

    bye_strstr:
        sub rdx, r8
        lea rax, [rdi + rdx]
        ret

_start:
    mov rdi, string
    mov rsi, to_find
    call my_strstr
    mov rdi, rax
    call my_putstr
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

_bye:
    mov rax, 60
    mov rdi, 84
    syscall
