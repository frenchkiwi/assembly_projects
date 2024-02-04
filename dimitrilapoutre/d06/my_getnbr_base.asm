section .data
    string dq "---1000", 0
    base dq "0123456789", 0

section .text
    global _start

my_getnbr_base:
    mov r8, 1
    mov r9, 0
    mov r10, -1
    loop_getnbr_base_len:
        inc r10
        cmp byte [rsi + r10], 0
        jne loop_getnbr_base_len
    mov rax, 0
    mov rcx, -1
    loop_getnbr_base:
        inc rcx

        cmp rax, 2147483647
        jg zero_getnbr_base
        cmp rax, -2147483648
        jl zero_getnbr_base

        cmp byte [rdi + rcx], 0
        je bye_getnbr_base
        cmp byte [rdi + rcx], 45
        je neg_getnbr_base
        cmp byte [rdi + rcx], 43
        je pos_getnbr_base
        call check_getnbr_base
        mov r9, 1
        
        mul r10
        add rax, r11

        jmp loop_getnbr_base

    check_getnbr_base:
        mov r11, -1
        loop_check_getnbr_base:
            inc r11
            cmp r11, r10
            je bye_getnbr_base
            mov r12b, byte [rsi + r11]
            cmp byte [rdi + rcx], r12b
            je bye_check_getnbr_base
            jmp loop_check_getnbr_base
        bye_check_getnbr_base:
            ret
    
    zero_getnbr_base:
        mov rax, 0
        ret

    pos_getnbr_base:
        cmp r9, 0
        jne bye_getnbr_base
        jmp loop_getnbr_base

    neg_getnbr_base:
        cmp r9, 0
        jne bye_getnbr_base
        neg r8
        jmp loop_getnbr_base

    bye_getnbr_base:
        cmp r8, 1
        je bye_getnbr_base2
        neg rax
        bye_getnbr_base2:
            ret

_start:
    mov rdi, string
    mov rsi, base
    call my_getnbr_base
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall