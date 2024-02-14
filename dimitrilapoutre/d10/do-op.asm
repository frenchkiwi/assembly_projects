%include "my_macro.asm"

section .data
    error_div db "Stop: division by zero", 0
    error_mod db "Stop: modulo by zero", 0
    base db "0123456789", 0

section .text
    extern my_getnbr
    extern my_putstr
    extern my_putnbr_base
    extern my_putchar
    global _start

get_sign:
    mov rax, 0
    cmp byte[rdi], '+'
    je .add
    cmp byte[rdi], '-'
    je .sub
    cmp byte[rdi], '*'
    je .mul
    cmp byte[rdi], '/'
    je .div
    cmp byte[rdi], '%'
    je .mod
    .bye:
    ret
    .add:
        mov rax, 1
        jmp .bye
    .sub:
        mov rax, 2
        jmp .bye
    .mul:
        mov rax, 3
        jmp .bye
    .div:
        mov rax, 4
        jmp .bye
    .mod:
        mov rax, 5
        jmp .bye

calcul:
    cmp rsi, 1
    je .add
    cmp rsi, 2
    je .sub
    cmp rsi, 3
    je .mul
    cmp rsi, 4
    je .div
    cmp rsi, 5
    je .mod
    CALL_ my_putchar, '0'
    CALL_ my_putchar, 10
    jmp _error
    .add:
        add rdi, rdx
        CALL_ my_putnbr_base, rdi, base
        CALL_ my_putchar, 10
        jmp _exit
    .sub:
        sub rdi, rdx
        CALL_ my_putnbr_base, rdi, base
        CALL_ my_putchar, 10
        jmp _exit
    .mul:
        mov rax, rdi
        mul rdx
        CALL_ my_putnbr_base, rax, base
        CALL_ my_putchar, 10
        jmp _exit
    .div:
        cmp rdx, 0
        je .error_div
        mov rax, rdi
        mov rbx, rdx
        xor rdx, rdx
        div rbx
        CALL_ my_putnbr_base, rax, base
        CALL_ my_putchar, 10
        jmp _exit
    .mod:
        cmp rdx, 0
        je .error_mod
        mov rax, rdi
        mov rbx, rdx
        xor rdx, rdx
        div rbx
        CALL_ my_putnbr_base, rdx, base
        CALL_ my_putchar, 10
        jmp _exit
    
    .error_div:
        CALL_ my_putstr, error_div
        CALL_ my_putchar, 10
        jmp _error
    
    .error_mod:
        CALL_ my_putstr, error_mod
        CALL_ my_putchar, 10
        jmp _error

_start:
    xor rdi, rdi
    mov rdi, [rsp + 16]
    cmp rdi, 0
    je _error
    CALL_ my_getnbr, rdi
    mov rdi, rax

    xor rsi, rsi
    mov rsi, [rsp + 24]
    cmp rsi, 0
    je _error
    CALL_ get_sign, rsi
    mov rsi, rax

    xor rdx, rdx
    mov rdx, [rsp + 32]
    cmp rdx, 0
    je _error
    CALL_ my_getnbr, rdx
    mov rdx, rax

    jmp calcul

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

_error:
    mov rax, 60
    mov rdi, 84
    syscall
