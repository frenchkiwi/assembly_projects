section .data
    a db 'c'
    b db 'h'
    c db 6, 6, 7

section .text
    global _start

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
    mov r8b, byte [a]
    mov r9b, byte [b]
    mov byte [a], r9b
    mov byte [b], r8b
    call write
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
