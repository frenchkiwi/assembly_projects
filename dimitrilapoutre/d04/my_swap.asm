section .data
    a db 'c'
    b db 'h'

section .text
    global _start

my_swap:
    xchg rdi, rsi
    ret

write:
    mov rax, 1
    mov rdi, 1
    mov rsi, a
    mov rdx, 1
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, b
    mov rdx, 1
    syscall
    ret
_start:
    call write
    movzx rdi, byte [a]
    movzx rsi, byte [b]
    call my_swap
    mov qword [a], rdi
    mov qword [b], rsi
    call write
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
