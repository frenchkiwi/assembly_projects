section .data

section .text
    global _start

my_show_param_array:
    mov rcx, 0
    .loop:
        cmp qword [rdi + rcx * 8], 0
        je .bye
        mov r12, [rdi + rcx * 8]
        push rdi
        push rcx
        mov edi, [r12]
        mov rsi, base
        call my_putnbr_base
        mov rdi, 10
        call my_putchar
        mov rdi, [r12 + 4]
        call my_putstr
        mov rdi, 10
        call my_putchar
        mov rdi, [r12 + 12]
        call my_putstr
        mov rdi, 10
        call my_putchar
        mov rdi, [r12 + 20]
        call my_show_word_array
        pop rcx
        pop rdi
        inc rcx
        jmp .loop
    .bye:
    ret

_start:

    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
