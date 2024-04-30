section .data
    string db "hello world", 0
section .text
    global _start

my_strlen:
    mov rax, -1
    loop:
        inc rax
        cmp byte [rdi + rax], 0
        jne loop
    ret

_start:
    mov rdi, string
    call my_strlen
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
