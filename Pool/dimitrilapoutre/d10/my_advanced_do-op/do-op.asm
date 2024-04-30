%include "my_macro.asm"
%include "../d10/my_advanced_do-op/my_opp.asm"

section .data
    error_div db "Stop: division by zero", 0
    error_mod db "Stop: modulo by zero", 0
    error_usage1 db "error: only [ ", 0
    error_usage2 db "] are supported", 0
    base db "0123456789", 0

section .text
    extern my_getnbr
    extern my_puterror
    extern my_putstr
    extern my_strncmp
    extern my_putnbr_base
    extern my_strlen
    extern my_putcharerror
    extern my_putchar
    global _start

calcul:
    mov rcx, -1
    .loop:
        inc rcx
        mov r8, [OPERATOR_FUNCS + rcx * 8]
        mov r9, [r8]
        CALL_ my_strlen, r9
        CALL_ my_strncmp, r9, rsi, rax
        cmp rax, 0
        je .jump
        jmp .loop
    .jump:
        jmp [r8 + 8]
    my_usage:
        CALL_ my_puterror, error_usage1
        mov rcx, -1
        .loop2:
            inc rcx
            mov r8, [OPERATOR_FUNCS + rcx * 8]
            mov r9, [r8]
            cmp byte [r9], 0
            je .continue
            mov r9, [r8]
            CALL_ my_puterror, r9
            CALL_ my_putcharerror, ' '
            jmp .loop2
        .continue:
        CALL_ my_puterror, error_usage2
        CALL_ my_putcharerror, 10
        jmp _error
    my_add:
        add rdi, rdx
        CALL_ my_putnbr_base, rdi, base
        CALL_ my_putchar, 10
        jmp _exit
    my_sub:
        sub rdi, rdx
        CALL_ my_putnbr_base, rdi, base
        CALL_ my_putchar, 10
        jmp _exit
    my_mul:
        mov rax, rdi
        mul rdx
        CALL_ my_putnbr_base, rax, base
        CALL_ my_putchar, 10
        jmp _exit
    my_div:
        cmp rdx, 0
        je .error_div
        mov rax, rdi
        mov rbx, rdx
        xor rdx, rdx
        div rbx
        CALL_ my_putnbr_base, rax, base
        CALL_ my_putchar, 10
        jmp _exit
        .error_div:
            CALL_ my_puterror, error_div
            CALL_ my_putcharerror, 10
            jmp _error
    my_mod:
        cmp rdx, 0
        je .error_mod
        mov rax, rdi
        mov rbx, rdx
        xor rdx, rdx
        div rbx
        CALL_ my_putnbr_base, rdx, base
        CALL_ my_putchar, 10
        jmp _exit
        .error_mod:
            CALL_ my_puterror, error_mod
            CALL_ my_putcharerror, 10
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

    xor rdx, rdx
    mov rdx, [rsp + 32]
    cmp rdx, 0
    je _error
    CALL_ my_getnbr, rdx
    mov rdx, rax

    xor rsi, rsi
    mov rsi, [rsp + 24]
    cmp rsi, 0
    je _error

    jmp calcul

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

_error:
    mov rax, 60
    mov rdi, 84
    syscall
