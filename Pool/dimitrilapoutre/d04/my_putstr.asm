section .data
    string db 'hello world', 10, 0

section .text
    global _start

my_putstr:
    mov rsi, rdi
    mov rdx, -1
    loop_putstr:
        inc rdx
        cmp byte [rsi + rdx], 0
        jne loop_putstr
    mov rax, 1
    mov rdi, 1
    syscall
    bye_putstr:
        ret
    
_start:
    mov rdi, string
    call my_putstr
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
