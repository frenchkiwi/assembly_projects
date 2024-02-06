section .rodata
    string db "hello gay homo pd     _sale merde", 0
section .text
    extern my_putstr
    extern my_show_word_array
    global _start

my_str_to_word_array:
    ; count_word
    mov rcx, -1
    mov rdx, 0
    mov r8, 0
    count_word_stwa:
        inc rcx
        check_digit_stwa:
            cmp byte [rdi + rcx], '0'
            jl new_word_stwa
            cmp byte [rdi + rcx], '9'
            jg check_alpha_stwa
            jmp up_r8_stwa
        check_alpha_stwa:
            cmp byte [rdi + rcx], 'A'
            jl new_word_stwa
            cmp byte [rdi + rcx], 'z'
            jg new_word_stwa
        check_ALPHA_stwa:
            cmp byte [rdi + rcx], 'Z'
            jle up_r8_stwa
            cmp byte [rdi + rcx], 'a'
            jge up_r8_stwa
        new_word_stwa:
            cmp r8, 1
            je add_word_stwa
            jmp return_count_word_stwa
            add_word_stwa:
                inc rdx
                mov r8, 0
                jmp return_count_word_stwa
        up_r8_stwa:
            mov r8, 1
        return_count_word_stwa:
        cmp byte [rdi + rcx], 0
        jne count_word_stwa

    ; malloc the array
    push rdi
    mov rax, 12
    mov rdi, 0
    syscall
    mov rsi, rax

    lea rdi, [8 + rsi + rdx * 8]
    mov rax, 12
    syscall
    pop rdi

    ; count_len_word
    mov rcx, -1
    mov rdx, 0
    mov r8, 0
    count_word_len_stwa:
        inc rcx
        check_digit_len_stwa:
            cmp byte [rdi + rcx], '0'
            jl new_word_len_stwa
            cmp byte [rdi + rcx], '9'
            jg check_alpha_len_stwa
            jmp up_r8_len_stwa
        check_alpha_len_stwa:
            cmp byte [rdi + rcx], 'A'
            jl new_word_len_stwa
            cmp byte [rdi + rcx], 'z'
            jg new_word_len_stwa
        check_ALPHA_len_stwa:
            cmp byte [rdi + rcx], 'Z'
            jle up_r8_len_stwa
            cmp byte [rdi + rcx], 'a'
            jge up_r8_len_stwa
        new_word_len_stwa:
            cmp r8, 0
            jg add_word_len_stwa
            jmp return_count_word_len_stwa
            add_word_len_stwa:
                ; malloc word
                push rdi
                push rsi
                push rcx
                mov rax, 12
                mov rdi, 0
                syscall
                mov r9, rax

                lea rdi, [r9 + r8 + 1]
                mov rax, 12
                syscall
                pop rcx
                pop rsi
                pop rdi
                mov [rsi + rdx * 8], r9
                inc rdx
                mov r8, 0
                jmp return_count_word_len_stwa
        up_r8_len_stwa:
            inc r8
        return_count_word_len_stwa:
        cmp byte [rdi + rcx], 0
        jne count_word_len_stwa
    mov qword [rsi + rdx * 8], 0

    ; add value
    mov rcx, -1
    mov rdx, 0
    mov r8, 0
    mov r10, 8
    count_word_add_stwa:
        inc rcx
        check_digit_add_stwa:
            cmp byte [rdi + rcx], '0'
            jl new_word_add_stwa
            cmp byte [rdi + rcx], '9'
            jg check_alpha_add_stwa
            jmp up_r8_add_stwa
        check_alpha_add_stwa:
            cmp byte [rdi + rcx], 'A'
            jl new_word_add_stwa
            cmp byte [rdi + rcx], 'z'
            jg new_word_add_stwa
        check_ALPHA_add_stwa:
            cmp byte [rdi + rcx], 'Z'
            jle up_r8_add_stwa
            cmp byte [rdi + rcx], 'a'
            jge up_r8_add_stwa
        new_word_add_stwa:
            cmp r8, 0
            jg add_word_add_stwa
            jmp return_count_word_add_stwa
            add_word_add_stwa:
                mov r10, [rsi + rdx * 8]
                mov byte [r10 + r8], 0
                inc rdx
                mov r8, 0
                jmp return_count_word_add_stwa
        up_r8_add_stwa:
            mov r9b, byte [rdi + rcx]
            mov r10, [rsi + rdx * 8]
            mov byte [r10 + r8], r9b
            inc r8
        return_count_word_add_stwa:
        cmp byte [rdi + rcx], 0
        jne count_word_add_stwa
    
    mov rax, rsi
    ret

_start:
    mov rdi, string
    call my_str_to_word_array
    mov rdi, rax
    call my_show_word_array
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
