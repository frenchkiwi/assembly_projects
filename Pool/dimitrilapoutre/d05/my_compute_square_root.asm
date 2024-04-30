section .data

section .text
    global _start

my_compute_square_root:
    cmp rdi, 0
    jle zero_square_root
    
    mov rsi, 0
    loop_square_root:
        inc rsi
        mov rax, rsi
        mul rsi
        cmp rax, rdi
        jl loop_square_root
    
    cmp rax, rdi
    jg zero_square_root

    mov rax, rsi
    ret

    zero_square_root:
        mov rax, 0
        ret

_start:
    mov rdi, 8
    call my_compute_square_root
    jmp _exit

_exit:
    mov rdi, rax
    mov rax, 60
    syscall
