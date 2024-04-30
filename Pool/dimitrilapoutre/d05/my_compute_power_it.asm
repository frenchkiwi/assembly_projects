section .data

section .text
    global _start

my_compute_power_it:
    cmp rsi, 0
    jl neg_power_it
    cmp rsi, 0
    je zero_power_it

    mov rax, 1
    loop_power_it:
        dec rsi

        mul rdi

        cmp rsi, 0
        jne loop_power_it
    ret

    zero_power_it:
        mov rax, 1
        ret
    
    neg_power_it:
        mov rax, 0
        ret

_start:
    mov rdi, 5
    mov rsi, -1
    call my_compute_power_it
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
