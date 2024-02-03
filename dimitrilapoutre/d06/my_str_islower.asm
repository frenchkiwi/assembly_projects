section .data
    string db "zizi", 0

section .text
    extern my_putstr
    global _start

my_str_islower:
    mov rcx, -1
    loop_islower:
        inc rcx
        cmp byte [rdi + rcx], 0
        je one_islower
        jmp check_islower

    check_islower:
        cmp byte [rdi + rcx], 'a'
        jl zero_islower
        cmp byte [rdi + rcx], 'z'
        jg zero_islower
        jmp loop_islower

    zero_islower:
        mov rax, 0 
        ret
    
    one_islower:
        mov rax, 1
        ret

_start:
    mov rdi, string
    call my_str_islower
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
