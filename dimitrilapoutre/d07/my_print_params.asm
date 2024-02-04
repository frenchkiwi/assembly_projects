section .data
    base db "0123456789", 0
section .text
    extern my_putstr
    extern my_putnbr_base
    global _start

_start:
    mov rdx, 1
    loop_print_params:
        mov rdi, 0
        mov rdi, [rsp + 8 * rdx]
        cmp rdi, 0
        je bye_print_params
        push rdx
        push rdi
        call my_putstr
        pop r8
        mov r9b, byte [r8]
        mov byte [r8], 10
        mov rax, 1
        lea rsi, [r8]
        mov rdi, 1
        mov rdx, 1
        syscall
        mov byte [r8], r9b
        pop rdx
        inc rdx
        jmp loop_print_params
    bye_print_params:
        jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
