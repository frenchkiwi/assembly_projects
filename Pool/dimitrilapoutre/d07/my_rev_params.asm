section .data
    base db "0123456789", 0
section .text
    extern my_putstr
    extern my_putnbr_base
    global _start

_start:
    mov rdx, 0
    loop_rev_params_len:
        inc rdx
        mov rdi, 0
        mov rdi, [rsp + 8 * rdx]
        cmp rdi, 0
        jne loop_rev_params_len
    dec rdx
    loop_rev_params:
        mov rdi, 0
        mov rdi, [rsp + 8 * rdx]
        cmp rdi, 0
        je bye_rev_params
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
        dec rdx
        cmp rdx, 0
        jne loop_rev_params
    bye_rev_params:
        jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
