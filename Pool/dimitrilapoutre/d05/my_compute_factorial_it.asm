section .data

section .text
    global _start

my_compute_factorial_it:
    mov rax, 1
    mov rcx, 0
    cmp rdi, 0
    jl error_factorial_it
    loop_factorial_it:
        inc rcx
        cmp rcx, rdi
        jg bye_factorial_it
        
        mov rdx, rcx
        mul rdx

        jmp loop_factorial_it

    bye_factorial_it:
        ret

    error_factorial_it:
        mov rax, -1
        ret

_start:
    mov rdi, -1
    call my_compute_factorial_it
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
