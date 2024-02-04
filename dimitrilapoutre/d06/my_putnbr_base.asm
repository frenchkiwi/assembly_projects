section .data
    base db "0123456789", 0

section .text
    extern my_compute_power_it
    global _start



my_putnbr_base:
    cmp rdi, 0
    jl my_putnbr_base_neg
    call my_putnbr_base_pos
    ret

    my_putnbr_base_neg:
        mov r9, rdi
        mov r8b, byte [rsi]
        mov byte [rsi], 45
        mov rax, 1
        mov rdi, 1
        mov rdx, 1
        syscall

        mov byte [rsi], r8b
        mov rdi, r9

        neg rdi
        call my_putnbr_base_pos
        ret

    my_putnbr_base_pos:
        mov r8, rdi
        mov r9, rsi

        mov r10, -1
        loop_putnbr_base_len2:
            inc r10
            cmp byte [r9 + r10], 0
            jne loop_putnbr_base_len2

        mov r11, 0
        loop_putnbr_base_len:
            inc r11

            mov rdi, r10
            mov rsi, r11
            call my_compute_power_it

            mov rbx, rax
            mov rax, r8
            xor rdx, rdx
            div rbx

            cmp rax, 1
            jge loop_putnbr_base_len


        loop_putnbr_base:
            dec r11

            mov rdi, r10
            mov rsi, r11
            call my_compute_power_it
            mov rbx, rax
            mov rax, r8
            xor rdx, rdx
            div rbx


            mov r8, rdx
            push r11
            lea rsi, [r9 + rax]
            mov rax, 1
            mov rdi, 1
            mov rdx, 1
            syscall
            pop r11

            cmp r11, 0
            jne loop_putnbr_base
        mov rax, 0
        ret

_start:
    mov rdi, 301
    mov rsi, base
    call my_putnbr_base
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
