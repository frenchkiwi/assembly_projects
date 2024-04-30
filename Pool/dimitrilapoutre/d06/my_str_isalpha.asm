section .data
    string db "hello world", 0

section .text
    extern my_putstr
    global _start

my_str_isalpha:
    mov rcx, -1
    loop_isalpha:
        inc rcx
        cmp byte [rdi + rcx], 0
        je one_isalpha
        jmp check_isalpha

    check_isalpha:
        cmp byte [rdi + rcx], 'A'
        jl zero_isalpha
        cmp byte [rdi + rcx], 'z'
        jg zero_isalpha
        jmp check_isalpha2

    check_isalpha2:
        cmp byte [rdi + rcx], 'Z'
        jle loop_isalpha
        cmp byte [rdi + rcx], 'a'
        jge loop_isalpha
        jmp zero_isalpha

    zero_isalpha:
        mov rax, 0 
        ret
    
    one_isalpha:
        mov rax, 1
        ret

_start:
    mov rdi, string
    call my_str_isalpha
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
