section .rodata
    nbr db "1010101101", 0
    base_from db "01", 0
    base_to db "0123456789ABCDEF", 0

    base_test db "0123456789", 0
section .text
    extern my_getnbr_base
    extern my_putnbr_base
    extern my_compute_power_it
    extern my_putstr
    global _start

convert_base:
    push rdx
    call my_getnbr_base
    pop rsi

    mov rdi, rax
    cmp rdi, 0
    jl my_convert_base_neg
    mov rcx, 0
    call my_convert_base_pos
    ret

    my_convert_base_neg:
        mov rcx, 1
        call my_convert_base_pos
        ret

    my_convert_base_pos:

        mov r9, -1
        loop_convert_base_len2:
            inc r9
            cmp byte [rsi + r9], 0
            jne loop_convert_base_len2

        mov r8, 0
        loop_convert_base_len:
            inc r8

            push rdi
            push rsi
            mov rdi, r9
            mov rsi, r8
            call my_compute_power_it
            pop rsi
            pop rdi

            mov rbx, rax
            mov rax, rdi
            xor rdx, rdx
            div rbx

            cmp rax, 1
            jge loop_convert_base_len
        
        add r8, rcx
        inc r8

        push rdi
        push rcx
        mov rax, 12
        mov rdi, 0
        syscall
        
        push rax
        lea rdi, [rax + r8]
        mov rax, 12
        syscall
        pop rax
        pop rcx
        pop rdi
        
        dec r8
        mov r10, r8
        dec r10
        loop_convert_base:
            dec r8

            push rax
            push rdi
            push rsi
            mov rdi, r9
            mov rsi, r8
            call my_compute_power_it
            pop rsi
            pop rdi

            mov rbx, rax
            mov rax, rdi
            xor rdx, rdx
            div rbx

            mov rdi, rdx
            mov rdx, rax
            pop rax

            mov dl, [rsi + rdx]
            mov r11, r10
            sub r11, r8
            add r11, rcx
            mov byte [rax + r11], dl

            cmp r8, rcx
            jne loop_convert_base
        cmp rcx, 0
        je bye_convert_base
        mov byte [rax], '-'
        bye_convert_base:
        ret

_start:
    mov rdi, nbr
    mov rsi, base_from
    mov rdx, base_to
    call convert_base
    mov rdi, rax
    call my_putstr
    jmp _exit

_exit:
    mov rdi, 0
    mov rax, 60
    syscall
