section .data
    string db "ZIZI-", 0

section .text
    extern my_putstr
    global _start

my_str_isupper:
    mov rcx, -1
    loop_isupper:
        inc rcx
        cmp byte [rdi + rcx], 0
        je one_isupper
        jmp check_isupper

    check_isupper:
        cmp byte [rdi + rcx], 'A'
        jl zero_isupper
        cmp byte [rdi + rcx], 'Z'
        jg zero_isupper
        jmp loop_isupper

    zero_isupper:
        mov rax, 0 
        ret
    
    one_isupper:
        mov rax, 1
        ret

_start:
    mov rdi, string
    call my_str_isupper
    jmp _exit

_exit:
    mov rdi, rax
    mov rax, 60
    syscall
