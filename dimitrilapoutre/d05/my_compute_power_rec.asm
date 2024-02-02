section .data

section .text
    global _start

my_compute_power_rec:
    pop rdx
    pop rsi
    pop rdi
    push rdi
    push rsi
    push rdx

    cmp rsi, 0
    jl neg_power_rec
    cmp rsi, 0
    je zero_power_rec

    dec rsi
    push rdi
    push rsi
    call my_compute_power_rec
    pop rsi
    pop rdi

    mul rdi
    ret

    zero_power_rec:
        mov rax, 1
        ret
    
    neg_power_rec:
        mov rax, 0
        ret

_start:
    push 5
    push -1
    call my_compute_power_rec
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
