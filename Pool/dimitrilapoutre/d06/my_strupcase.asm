section .data
    string db "hello world", 0

section .text
    extern my_putstr
    global _start

my_strupcase:
    mov rcx, -1
    loop_strupcase:
        inc rcx
        cmp byte [rdi + rcx], 'a'
        jl again_loop_strupcase
        cmp byte [rdi + rcx], 'z'
        jg again_loop_strupcase
        sub byte [rdi + rcx], 32
        again_loop_strupcase:
            cmp byte [rdi + rcx], 0
            jne loop_strupcase
    mov rax, rdi
    ret

_start:
    mov rdi, string
    call my_strupcase
    mov rdi, rax
    call my_putstr
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
