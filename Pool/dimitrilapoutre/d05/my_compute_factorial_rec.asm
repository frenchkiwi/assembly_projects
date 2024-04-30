section .data

section .text
    global _start

my_compute_factorial_rec:
    pop rsi
    pop rdi
    push rdi
    push rsi
    cmp rdi, 0
    jl error_factorial_rec

    cmp rdi, 0
    je bye_factorial_rec2

    dec rdi
    push rdi
    call my_compute_factorial_rec
    
    pop rsi
    pop rdi
    push rsi
    mul rdi

    bye_factorial_rec:
        ret

    bye_factorial_rec2:
        pop rsi
        pop rdi
        push rsi
        mov rax, 1
        ret

    error_factorial_rec:
        mov rax, -1
        ret

_start:
    push 3
    call my_compute_factorial_rec
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
