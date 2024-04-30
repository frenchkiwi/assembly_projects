section .data
    string db "TEST-", 0

section .text
    extern my_putstr
    global _start

my_str_isprintable:
    mov rcx, -1
    loop_isprintable:
        inc rcx
        cmp byte [rdi + rcx], 0
        je one_isprintable
        jmp check_isprintable

    check_isprintable:
        cmp byte [rdi + rcx], ' '
        jl zero_isprintable
        cmp byte [rdi + rcx], '~'
        jg zero_isprintable
        jmp loop_isprintable

    zero_isprintable:
        mov rax, 0 
        ret
    
    one_isprintable:
        mov rax, 1
        ret

_start:
    mov rdi, string
    call my_str_isprintable
    jmp _exit

_exit:
    mov rdi, rax
    mov rax, 60
    syscall
