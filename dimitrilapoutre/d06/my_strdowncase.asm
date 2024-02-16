section .data
    string db "hElLo WorLd", 0

section .text
    extern my_putstr
    global _start

my_strdowncase:
    mov rcx, -1
    loop_strdowncase:
        inc rcx
        cmp byte [rdi + rcx], 'A'
        jl again_loop_strdowncase
        cmp byte [rdi + rcx], 'Z'
        jg again_loop_strdowncase
        add byte [rdi + rcx], 32
        again_loop_strdowncase:
            cmp byte [rdi + rcx], 0
            jne loop_strdowncase
    mov rax, rdi
    ret

_start:
    mov rdi, string
    call my_strdowncase
    mov rdi, rax
    call my_putstr
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
