section .data
    letter db 48

section .text
    global _start

my_print_digits:
    loop:
        mov rax, 1
        mov rdi, 1
        mov rsi, letter
        mov rdx, 1
        syscall

        inc byte [letter]
        cmp byte [letter], 58
        jne loop
    ret

_start:
    call my_print_digits
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
