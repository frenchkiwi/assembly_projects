section .data
    letter db 122

section .text
    global _start

my_print_revalpha:
    loop:
        mov rax, 1
        mov rdi, 1
        mov rsi, letter
        mov rdx, 1
        syscall
        dec byte [letter]
        cmp byte [letter], 96
        jne loop
    ret

_start:
    call my_print_revalpha
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
