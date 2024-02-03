section .data
    string db "69-", 0

section .text
    extern my_putstr
    global _start

my_str_isnum:
    mov rcx, -1
    loop_isnum:
        inc rcx
        cmp byte [rdi + rcx], 0
        je one_isnum
        jmp check_isnum

    check_isnum:
        cmp byte [rdi + rcx], '0'
        jl zero_isnum
        cmp byte [rdi + rcx], '9'
        jg zero_isnum
        jmp loop_isnum

    zero_isnum:
        mov rax, 0 
        ret
    
    one_isnum:
        mov rax, 1
        ret

_start:
    mov rdi, string
    call my_str_isnum
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
