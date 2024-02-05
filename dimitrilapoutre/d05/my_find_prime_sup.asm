section .data

section .text
    global _start

my_find_prime_sup:
    cmp rdi, 1
    jle zero_prime_sup

    mov rax, rdi
    xor rdx, rdx
    mov rbx, 2
    div rbx

    cmp rdi, 2
    je one_prime_sup

    cmp rdx, 0
    je zero_prime_sup

    mov r8, rax
    loop_prime_sup:
        inc rbx
        cmp rbx, r8
        jge one_prime_sup

        mov rax, rdi
        xor rdx, rdx
        div rbx

        cmp rdx, 0
        je zero_prime_sup
        jmp loop_prime_sup

    one_prime_sup:
        mov rax, rdi
        ret
    zero_prime_sup:
        inc rdi
        call my_find_prime_sup
        ret

_start:
    mov rdi, 8
    call my_find_prime_sup
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
