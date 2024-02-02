section .data

section .text
    global _start

my_is_prime:
    cmp rdi, 1
    jle zero_prime

    mov rax, rdi
    xor rdx, rdx
    mov rbx, 2
    div rbx

    cmp rdi, 2
    je one_prime

    cmp rdx, 0
    je zero_prime

    mov r8, rax
    loop_prime:
        inc rbx
        cmp rbx, r8
        jge one_prime

        mov rax, rdi
        xor rdx, rdx
        div rbx

        cmp rdx, 0
        je zero_prime
        jmp loop_prime

    one_prime:
        mov rax, 1
        ret
    zero_prime:
        mov rax, 0
        ret

_start:
    mov rdi, 31
    call my_is_prime
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
