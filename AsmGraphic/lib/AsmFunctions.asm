section .data
    malloc_base dq -1
    malloc_bug db "malloc(): memory allocation failed", 10
    free_error db "free(): invalid pointer", 10
    free_bug db "free(): bug memory release", 10

section .text
    global my_putchar
    global my_putcharerror
    global my_putnbr
    global my_strlen
    global my_putstr
    global my_puterror
    global my_getnbr
    global my_factorial
    global my_power
    global my_strcpy
    global my_strncpy
    global my_strstr
    global my_strcmp
    global my_strncmp
    global my_strcat
    global my_strncat
    global my_strdup
    global show_word_array
    global str_to_word_array
    global sort_word_array
    global advanced_sort_word_array
    global list_size
    global rev_list
    global apply_on_nodes
    global apply_on_matching_nodes
    global find_node
    global delete_nodes
    global concat_list
    global sort_list
    global get_ptr
    global add_in_sorted_list
    global merge
    global my_malloc
    global my_free
    global my_calloc
    global my_realloc
    global show_malloc
    global futex_lock
    global futex_unlock

%include "AsmFunctions.inc"

my_putchar:
    mov dl, dil
    mov rax, 12
    mov rdi, 0
    syscall
    mov rsi, rax
    mov rax, 12
    lea rdi, [rsi + 1]
    syscall
    
    mov byte [rsi], dl
    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    syscall

    mov rax, 12
    lea rdi, [rsi]
    syscall
    ret

my_putcharerror:
    push rax
    push rdi
    push rsi
    push rdx
    push rcx
    push r11

    mov dl, dil
    mov rax, 12
    mov rdi, 0
    syscall
    mov rsi, rax
    mov rax, 12
    lea rdi, [rsi + 1]
    syscall
    
    mov byte [rsi], dl
    mov rax, 1
    mov rdi, 2
    mov rdx, 1
    syscall

    mov rax, 12
    lea rdi, [rsi]
    syscall

    pop r11
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret

my_putnbr:
    cmp rdi, 0
    jl .my_putnbr_neg
    call .my_putnbr_pos
    ret

    .my_putnbr_neg:
        CALL_ my_putchar, '-'

        neg rdi
        call .my_putnbr_pos
        ret

    .my_putnbr_pos:
        mov r8, rdi

        mov r11, 0
        .loop_my_putnbr_len:
            inc r11

            mov rdi, 10
            mov rsi, r11
            call my_power

            mov rbx, rax
            mov rax, r8
            xor rdx, rdx
            div rbx

            cmp rax, 1
            jge .loop_my_putnbr_len
        
        .loop_my_putnbr:
            dec r11

            mov rdi, 10
            mov rsi, r11
            call my_power
            mov rbx, rax
            mov rax, r8
            xor rdx, rdx
            div rbx

            mov r8, rdx
            add rax, '0'
            CALL_ my_putchar, rax

            cmp r11, 0
            jne .loop_my_putnbr
        xor rax, rax
        ret


my_strlen:
    mov rax, -1
    .loop_my_strlen:
        inc rax
        cmp byte [rdi + rax], 0
        jne .loop_my_strlen
    ret

my_putstr:
    cmp rdi, 0
    je .bye_my_putstr
    mov rsi, rdi
    mov rdx, -1
    .loop_my_putstr:
        inc rdx
        cmp byte [rsi + rdx], 0
        jne .loop_my_putstr
    mov rax, 1
    mov rdi, 1
    syscall
    .bye_my_putstr:
        mov rax, 0
        ret

my_puterror:
    cmp rdi, 0
    je .bye_my_putstr
    mov rsi, rdi
    mov rdx, -1
    .loop_my_putstr:
        inc rdx
        cmp byte [rsi + rdx], 0
        jne .loop_my_putstr
    mov rax, 1
    mov rdi, 2
    syscall
    .bye_my_putstr:
        mov rax, 0
        ret

my_getnbr:
    mov r8, 1
    mov r9, 0
    mov rax, 0
    mov rcx, -1
    .loop_getnbr:
        cmp rax, 2147483647
        jg .zero_getnbr
        cmp rax, -2147483648
        jl .zero_getnbr
        inc rcx
        cmp byte [rdi + rcx], 45
        je .neg_getnbr
        cmp byte [rdi + rcx], 43
        je .pos_getnbr
        cmp byte [rdi + rcx], 48
        jl .bye_getnbr
        cmp byte [rdi + rcx], 57
        jg .bye_getnbr
        
        mov r9, 1
        mov rdx, 10
        mul rdx

        movzx rbx, byte [rdi + rcx]
        sub bl, 48
        add rax, rbx
        jmp .loop_getnbr

    .zero_getnbr:
        mov rax, 0
        ret

    .pos_getnbr:
        cmp r9, 0
        jne .bye_getnbr
        jmp .loop_getnbr

    .neg_getnbr:
        cmp r9, 0
        jne .bye_getnbr
        neg r8
        jmp .loop_getnbr

    .bye_getnbr:
        cmp r8, 1
        je .bye_getnbr2
        neg rax
        .bye_getnbr2:
            ret

my_factorial:
    mov rax, 1
    mov rcx, 0
    cmp rdi, 0
    jl .error_factorial_it
    .loop_factorial_it:
        inc rcx
        cmp rcx, rdi
        jg .bye_factorial_it
        
        mov rdx, rcx
        mul rdx

        jmp .loop_factorial_it

    .bye_factorial_it:
        ret

    .error_factorial_it:
        mov rax, -1
        ret

my_power:
    cmp rsi, 0
    jl .neg_power_it
    cmp rsi, 0
    je .zero_power_it

    mov rax, 1
    .loop_power_it:
        dec rsi

        mul rdi

        cmp rsi, 0
        jne .loop_power_it
    ret

    .zero_power_it:
        mov rax, 1
        ret
    
    .neg_power_it:
        mov rax, 0
        ret

my_strcpy:
    mov rcx, -1
    .loop_strcpy:
        inc rcx
        mov r8b, byte [rsi + rcx]
        mov byte [rdi + rcx], r8b
        cmp byte [rsi + rcx], 0
        jne .loop_strcpy
    mov rax, rdi
    ret

my_strncpy:
    mov rcx, -1
    .loop_strncpy:
        inc rcx
        cmp rdx, rcx
        je .bye_strncpy
        mov r8b, byte [rsi + rcx]
        mov byte [rdi + rcx], r8b
        cmp byte [rsi + rcx], 0
        jne .loop_strncpy
    .bye_strncpy:
        mov rax, rdi
        ret

my_strstr:
    mov r8, -1
    .loop_strmy_strlen:
        inc r8
        cmp byte [rsi + r8], 0
        jne .loop_strmy_strlen
    mov rdx, -1
    mov rcx, -1
    .loop_strstr:
        inc rdx
        inc rcx
        cmp rcx, r8
        je  .bye_strstr
        mov r9b, byte [rsi + rcx]
        cmp byte [rdi + rdx], r9b
        jne .reset_and_again_strstr
        .again_loop_strstr:
            cmp byte [rdi + rdx], 0
            jne .loop_strstr
    mov rax, 0
    ret

    .reset_and_again_strstr:
        mov rcx, -1
        jmp .again_loop_strstr

    .bye_strstr:
        sub rdx, r8
        lea rax, [rdi + rdx]
        ret

my_strcmp:
    mov rcx, -1
    .loop_strcmp:
        inc rcx
        mov r9b, byte [rsi + rcx]
        cmp byte [rdi + rcx], r9b
        jne .bye_strcmp
        cmp byte [rdi + rcx], 0
        jne .loop_strcmp
    mov rax, 0
    ret

    .bye_strcmp:
        movzx rax, byte [rdi + rcx]
        movzx rbx, byte [rsi + rcx]
        sub rax, rbx
        ret

my_strncmp:
    mov rcx, -1
    .loop_strcmp:
        dec rdx
        cmp rdx, 0
        je .bye
        inc rcx
        mov r9b, byte [rsi + rcx]
        cmp byte [rdi + rcx], r9b
        jne .bye_strcmp
        cmp byte [rdi + rcx], 0
        jne .loop_strcmp
    .bye:
    mov rax, 0
    ret

    .bye_strcmp:
        movzx rax, byte [rdi + rcx]
        movzx rbx, byte [rsi + rcx]
        sub rax, rbx
        ret
my_putnbr_base:
    cmp rdi, 0
    jl .my_putnbr_base_neg
    call .my_putnbr_base_pos
    ret

    .my_putnbr_base_neg:
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
        call .my_putnbr_base_pos
        ret

    .my_putnbr_base_pos:
        mov r8, rdi
        mov r9, rsi

        mov r10, -1
        .loop_my_putnbr_base_len2:
            inc r10
            cmp byte [r9 + r10], 0
            jne .loop_my_putnbr_base_len2

        mov r11, 0
        .loop_my_putnbr_base_len:
            inc r11

            mov rdi, r10
            mov rsi, r11
            call my_power

            mov rbx, rax
            mov rax, r8
            xor rdx, rdx
            div rbx

            cmp rax, 1
            jge .loop_my_putnbr_base_len


        .loop_my_putnbr_base:
            dec r11

            mov rdi, r10
            mov rsi, r11
            call my_power
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
            jne .loop_my_putnbr_base
        mov rax, 0
        ret

my_getnbr_base:
    mov r8, 1
    mov r9, 0
    mov r10, -1
    .loop_getnbr_base_len:
        inc r10
        cmp byte [rsi + r10], 0
        jne .loop_getnbr_base_len
    mov rax, 0
    mov rcx, -1
    .loop_getnbr_base:
        inc rcx

        cmp rax, 2147483647
        jg .zero_getnbr_base
        cmp rax, -2147483648
        jl .zero_getnbr_base

        cmp byte [rdi + rcx], 0
        je .bye_getnbr_base
        cmp byte [rdi + rcx], 45
        je .neg_getnbr_base
        cmp byte [rdi + rcx], 43
        je .pos_getnbr_base
        call .check_getnbr_base
        mov r9, 1
        
        mul r10
        add rax, r11

        jmp .loop_getnbr_base

    .check_getnbr_base:
        mov r11, -1
        .loop_check_getnbr_base:
            inc r11
            cmp r11, r10
            je .bye_getnbr_base
            mov r12b, byte [rsi + r11]
            cmp byte [rdi + rcx], r12b
            je .bye_check_getnbr_base
            jmp .loop_check_getnbr_base
        .bye_check_getnbr_base:
            ret
    
    .zero_getnbr_base:
        mov rax, 0
        ret

    .pos_getnbr_base:
        cmp r9, 0
        jne .bye_getnbr_base
        jmp .loop_getnbr_base

    .neg_getnbr_base:
        cmp r9, 0
        jne .bye_getnbr_base
        neg r8
        jmp .loop_getnbr_base

    .bye_getnbr_base:
        cmp r8, 1
        je .bye_getnbr_base2
        neg rax
        .bye_getnbr_base2:
            ret

my_showstr:
    mov r8, rdi
    mov r9, -1
    .loop_showstr:
        inc r9
        cmp byte [r8 + r9], 0
        je .bye_showstr
        jmp .check_showstr

    .bye_showstr:
        mov rax, 0
        ret

    .check_showstr:
        cmp byte [r8 + r9], ' '
        jl .np_showstr
        cmp byte [r8 + r9], '~'
        jg .np_showstr
        jmp .p_showstr

    .p_showstr:
        mov rax, 1
        mov rdi, 1
        lea rsi, [r8 + r9]
        mov rdx, 1
        syscall
        jmp .loop_showstr

    .np_showstr:
        mov rax, 1
        mov rdi, 1
        mov rdx, 1

        mov bl, byte [r8]
        mov byte [r8], '\' 
        lea rsi, [r8]
        syscall
        mov byte [r8], bl
        
        movzx rax, byte [r8 + r9]
        xor rdx, rdx
        mov rbx, 16
        div rbx

        mov r10, rax
        add r10, 48
        mov r11, rdx
        add r11, 48

        mov rax, 1
        mov rdi, 1
        mov rdx, 1

        mov bl, byte [r8]
        call .is_hexa_showstr
        mov byte [r8], r10b
        lea rsi, [r8]
        mov r10, r11
        syscall
        call .is_hexa_showstr
        mov byte [r8], r10b
        lea rsi, [r8]
        syscall
        mov byte [r8], bl

        jmp .loop_showstr

        .is_hexa_showstr:
            cmp r10, 58
            jl .bye_is_hexa_showstr
            add r10, 39
            .bye_is_hexa_showstr:
                ret

my_showmem:
    mov r8, rdi
    mov r9, rsi
    mov r10, -1
    .loop_showmem:
        mov rcx, 8
        inc r10
        push r10
        call .print_adress_showmem

        pop r10
        dec r10
        
        .loop_showmem2:
            inc r10

            mov rax, r10
            xor rdx, rdx
            mov rbx, 16
            div rbx

            call .print_hexa_showmem

            push rdx
            mov rax, rdx
            xor rdx, rdx
            mov rbx, 2
            div rbx

            call .need_space_showmem
            pop rdx

            cmp rdx, 15
            jne .loop_showmem2
        sub r10, 16
        .loop_showmem3:
            inc r10
            
            cmp r10, r9
            je .print_newline_showmem

            mov rax, r10
            xor rdx, rdx
            mov rbx, 16
            div rbx

            call .print_showmem

            cmp rdx, 15
            jne .loop_showmem3
        .print_newline_showmem:
            mov bl, byte [r8]
            mov rax, 1
            mov rdi, 1
            mov byte [r8], 10
            lea rsi, [r8]
            mov rdx, 1
            syscall
            mov byte [r8], bl

            cmp r10, r9
            je .bye_showmem
            dec r9
            cmp r10, r9
            je .bye_showmem
            inc r9

            jmp .loop_showmem

    .bye_showmem:
        mov rax, 0
        ret

    .print_adress_showmem:
        dec rcx

        mov rdi, 16
        mov rsi, rcx
        call my_power

        mov rbx, rax
        mov rax, r10
        xor rdx, rdx
        div rbx
        
        mov r10, rdx

        mov bl, byte [r8]
        mov byte [r8], al
        add byte [r8], 48
        cmp byte [r8], 58
        jl .print_adress_part_showmem
        add byte [r8], 39
        .print_adress_part_showmem:
            push rcx
            mov rax, 1
            mov rdi, 1
            lea rsi, [r8]
            mov rdx, 1
            syscall
            mov byte [r8], bl
            pop rcx

        cmp rcx, 0
        jne .print_adress_showmem
        mov rax, 1
        mov rdi, 1
        mov rdx, 1

        mov bl, byte [r8]
        mov byte [r8], ':'
        lea rsi, [r8]
        syscall
        mov byte [r8], ' '
        lea rsi, [r8]
        syscall
        mov byte [r8], bl
        ret

    .print_hexa_showmem:
        push rdx

        mov rax, 1
        mov rdi, 1
        mov rdx, 1

        cmp r10, r9
        jge .print_hexa_empty_showmem
        
        movzx rax, byte [r8 + r10]
        xor rdx, rdx
        mov rbx, 16
        div rbx

        push r10
        mov r10, rax
        add r10, 48
        mov r11, rdx
        add r11, 48

        mov rax, 1
        mov rdi, 1
        mov rdx, 1

        mov bl, byte [r8]
        call .is_hexa_showmem
        mov byte [r8], r10b
        lea rsi, [r8]
        mov r10, r11
        syscall
        call .is_hexa_showmem
        mov byte [r8], r10b
        lea rsi, [r8]
        syscall
        mov byte [r8], bl
        pop r10

        pop rdx
        ret

        .is_hexa_showmem:
            cmp r10, 58
            jl .bye_is_hexa_showmem
            add r10, 39
            .bye_is_hexa_showmem:
                ret
        
        .print_hexa_empty_showmem:
            mov rax, 1
            mov rdi, 1
            mov rdx, 1

            mov bl, byte [r8]
            mov byte [r8], 32
            lea rsi, [r8]
            syscall
            mov byte [r8], 32
            lea rsi, [r8]
            syscall
            mov byte [r8], bl
            pop rdx
            ret

    .need_space_showmem:
        cmp rdx, 1
        je .print_space_showmem
        ret

        .print_space_showmem:
            mov bl, byte [r8]
            mov rax, 1
            mov rdi, 1
            mov byte [r8], 32
            lea rsi, [r8]
            mov rdx, 1
            syscall
            mov byte [r8], bl
            ret

    .print_showmem:
        push rdx
        cmp byte [r8 + r10], ' '
        jl .print_dot_showmem
        cmp byte [r8 + r10], '~'
        jg .print_dot_showmem

        mov rax, 1
        mov rdi, 1
        lea rsi, [r8 + r10]
        mov rdx, 1
        syscall

        .bye_print_showmem:
            pop rdx
            ret 
        .print_dot_showmem:
            mov bl, byte [r8]
            mov rax, 1
            mov rdi, 1
            mov byte [r8], 46
            lea rsi, [r8]
            mov rdx, 1
            syscall
            mov byte [r8], bl
            jmp .bye_print_showmem

my_strcat:
    mov rcx, -1
    .loop_destlen_strcat:
        inc rcx
        cmp byte [rdi + rcx], 0
        jne .loop_destlen_strcat
    mov rdx, -1
    .loop_strcat:
        inc rdx
        mov r8b, byte [rsi + rdx]
        add rcx, rdx
        mov byte [rdi + rcx], r8b
        sub rcx, rdx
        cmp byte [rsi + rdx], 0
        jne .loop_strcat
    mov rax, rdi
    ret

my_strncat:
    mov r9, rdx
    mov rcx, -1
    .loop_destlen_strncat:
        inc rcx
        cmp byte [rdi + rcx], 0
        jne .loop_destlen_strncat
    mov rdx, -1
    .loop_strncat:
        inc rdx
        cmp rdx, r9
        je .bye_strncat
        cmp byte [rsi + rdx], 0
        je .bye_strncat
        mov r8b, byte [rsi + rdx]
        add rcx, rdx
        mov byte [rdi + rcx], r8b
        sub rcx, rdx
        jmp .loop_strncat
    .bye_strncat:
        add rcx, rdx
        mov byte [rdi + rcx], 0
        mov rax, rdi
        ret

my_strdup:
    push rdi
    call my_strlen
    inc rax
    mov rdi, rax
    call my_malloc
    mov rdi, rax
    pop rsi
    call my_strcpy
    ret 

show_word_array:
    mov rsi, rdi
    mov rcx, -1
    .loop_show_word_array:
        inc rcx
        mov rdi, [rsi + rcx * 8]
        cmp rdi, 0
        je .bye_show_word_array
        push rsi
        push rcx
        call my_putstr
        pop rcx
        pop rsi
        push rsi
        push rcx
        mov r8b, byte [rsi + rcx * 8]
        mov rax, 1
        mov rdi, 1
        mov byte [rsi + rcx * 8], 10
        lea rsi, byte [rsi + rcx * 8]
        mov rdx, 1
        syscall
        pop rcx
        pop rsi
        mov byte [rsi + rcx * 8], r8b
        jmp .loop_show_word_array
    .bye_show_word_array:
    mov rax, 0
    ret

str_to_word_array:
    ; count_word
    mov rcx, -1
    mov rdx, 0
    mov r8, 0
    .count_word_stwa:
        inc rcx
        .check_digit_stwa:
            cmp byte [rdi + rcx], '0'
            jl .new_word_stwa
            cmp byte [rdi + rcx], '9'
            jg .check_alpha_stwa
            jmp .up_r8_stwa
        .check_alpha_stwa:
            cmp byte [rdi + rcx], 'A'
            jl .new_word_stwa
            cmp byte [rdi + rcx], 'z'
            jg .new_word_stwa
        .check_ALPHA_stwa:
            cmp byte [rdi + rcx], 'Z'
            jle .up_r8_stwa
            cmp byte [rdi + rcx], 'a'
            jge .up_r8_stwa
        .new_word_stwa:
            cmp r8, 1
            je .add_word_stwa
            jmp .return_count_word_stwa
            .add_word_stwa:
                inc rdx
                mov r8, 0
                jmp .return_count_word_stwa
        .up_r8_stwa:
            mov r8, 1
        .return_count_word_stwa:
        cmp byte [rdi + rcx], 0
        jne .count_word_stwa

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
    .count_word_len_stwa:
        inc rcx
        .check_digit_len_stwa:
            cmp byte [rdi + rcx], '0'
            jl .new_word_len_stwa
            cmp byte [rdi + rcx], '9'
            jg .check_alpha_len_stwa
            jmp .up_r8_len_stwa
        .check_alpha_len_stwa:
            cmp byte [rdi + rcx], 'A'
            jl .new_word_len_stwa
            cmp byte [rdi + rcx], 'z'
            jg .new_word_len_stwa
        .check_ALPHA_len_stwa:
            cmp byte [rdi + rcx], 'Z'
            jle .up_r8_len_stwa
            cmp byte [rdi + rcx], 'a'
            jge .up_r8_len_stwa
        .new_word_len_stwa:
            cmp r8, 0
            jg .add_word_len_stwa
            jmp .return_count_word_len_stwa
            .add_word_len_stwa:
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
                jmp .return_count_word_len_stwa
        .up_r8_len_stwa:
            inc r8
        .return_count_word_len_stwa:
        cmp byte [rdi + rcx], 0
        jne .count_word_len_stwa
    mov qword [rsi + rdx * 8], 0

    ; add value
    mov rcx, -1
    mov rdx, 0
    mov r8, 0
    mov r10, 8
    .count_word_add_stwa:
        inc rcx
        .check_digit_add_stwa:
            cmp byte [rdi + rcx], '0'
            jl .new_word_add_stwa
            cmp byte [rdi + rcx], '9'
            jg .check_alpha_add_stwa
            jmp .up_r8_add_stwa
        .check_alpha_add_stwa:
            cmp byte [rdi + rcx], 'A'
            jl .new_word_add_stwa
            cmp byte [rdi + rcx], 'z'
            jg .new_word_add_stwa
        .check_ALPHA_add_stwa:
            cmp byte [rdi + rcx], 'Z'
            jle .up_r8_add_stwa
            cmp byte [rdi + rcx], 'a'
            jge .up_r8_add_stwa
        .new_word_add_stwa:
            cmp r8, 0
            jg .add_word_add_stwa
            jmp .return_count_word_add_stwa
            .add_word_add_stwa:
                mov r10, [rsi + rdx * 8]
                mov byte [r10 + r8], 0
                inc rdx
                mov r8, 0
                jmp .return_count_word_add_stwa
        .up_r8_add_stwa:
            mov r9b, byte [rdi + rcx]
            mov r10, [rsi + rdx * 8]
            mov byte [r10 + r8], r9b
            inc r8
        .return_count_word_add_stwa:
        cmp byte [rdi + rcx], 0
        jne .count_word_add_stwa
    
    mov rax, rsi
    ret

sort_word_array:
    mov rcx, -1
    cmp rdi, 0
    je .bye
    .loop:
        inc rcx
        cmp qword[8 + rdi + rcx * 8], 0
        je .bye
        mov rdx, rcx
        inc rdx
        .loop2:
            mov r8, [rdi + rcx * 8]
            mov r9, [rdi + rdx * 8]
            CALL_ my_strcmp, r8, r9
            cmp rax, 0
            jg .swap
            .back_up_loop2:
            inc rdx
            cmp qword[rdi + rdx * 8], 0
            jne .loop2
        jmp .loop
    .bye:
    mov rax, 0
    ret

    .swap:
        mov [rdi + rcx * 8], r9
        mov [rdi + rdx * 8], r8
        jmp .back_up_loop2

advanced_sort_word_array:
    mov r10, rsi
    mov rcx, -1
    cmp rdi, 0
    je .bye
    .loop:
        inc rcx
        cmp qword[8 + rdi + rcx * 8], 0
        je .bye
        mov rdx, rcx
        inc rdx
        .loop2:
            mov r8, [rdi + rcx * 8]
            mov r9, [rdi + rdx * 8]
            CALL_ r10, r8, r9
            cmp rax, 0
            jg .swap
            .back_up_loop2:
            inc rdx
            cmp qword[rdi + rdx * 8], 0
            jne .loop2
        jmp .loop
    .bye:
    mov rax, 0
    ret

    .swap:
        mov [rdi + rcx * 8], r9
        mov [rdi + rdx * 8], r8
        jmp .back_up_loop2

list_size:
    mov rcx, -1
    mov rax, rdi
    .loop:
        inc rcx
        cmp rax, 0
        je .bye
        mov rax, qword [rax + 8]
        jmp .loop
    .bye:
    mov rax, rcx
    ret

rev_list:
    cmp rdi, 0
    je .bye
    mov r8, rdi
    mov rdi, qword [r8]
    mov rdx, qword [r8]
    .loop:
        cmp qword [rdi + 8], 0
        je .continue
        mov rdi, qword [rdi + 8]
        jmp .loop
    .continue:
    mov qword [r8], rdi
    mov rax, rdi
    .loop2:
        mov rsi, rdx
        .loop3:
            cmp qword [rsi + 8], rax
            je .add_next
            mov rsi, qword [rsi + 8]
            jmp .loop3
        .add_next:
        mov qword [rax + 8], rsi
        mov rax, rsi
        mov rsi, rdx
        cmp qword [rsi + 8], rax
        jne .loop2
    mov rsi, 0
    mov qword [rax + 8], rsi
    .bye:
    mov rax, r8
    ret

apply_on_nodes:
    mov r8, rdi
    .loop:
        cmp r8, 0
        je .bye
        CALL_ rsi, qword [r8]
        mov r8, qword [r8 + 8]
        jmp .loop
    .bye:
    mov rax, 0
    ret

apply_on_matching_nodes:
    mov r8, rdi
    .loop:
        cmp r8, 0
        je .bye
        CALL_ rcx, qword [r8], rdx
        cmp rax, 0
        jne .continue
        CALL_ rsi, qword [r8]
        .continue:
        mov r8, qword [r8 + 8]
        jmp .loop
    .bye:
    mov rax, 0
    ret

find_node:
    mov r8, rdi
    .loop:
        cmp r8, 0
        je .bye
        CALL_ rdx, qword [r8], rsi
        cmp rax, 0
        jne .continue
        mov rax, r8
        ret
        .continue:
        mov r8, qword [r8 + 8]
        jmp .loop
    .bye:
    mov rax, 0
    ret

delete_nodes:
    mov r8, qword [rdi]
    .loop:
        cmp r8, 0
        je .bye
        cmp r8, qword [rdi]
        je .first_node
        CALL_ rdx, qword [r8], rsi
        cmp rax, 0
        je .continue
        mov qword [r9 + 8], r8
        mov r9, qword [r9 + 8]
        .continue:
        mov r8, qword [r8 + 8]
        jmp .loop
    .bye:
    mov r11, qword [rdi]
    cmp r11, 0
    je .bye2
    mov qword [r9 + 8], r8
    .bye2:
    mov rax, 0
    ret

    .first_node:
        CALL_ rdx, qword [r8], rsi
        cmp rax, 0
        je .move_begin
        mov r9, r8
        jmp .continue
        .move_begin:
            mov r11, qword [r8 + 8]
            mov qword [rdi], r11
            jmp .continue

concat_list:
    mov r8, [rdi]
    cmp r8, 0
    je .no_first
    xor r9, r9
    .loop:
        cmp [r8 + 8], r9
        je .link
        mov r8, [r8 + 8]
        jmp .loop
    .link:
        mov [r8 + 8], rsi
    .bye:
    mov rax, 0
    ret
    .no_first:
        mov [rdi], rsi
        jmp .bye

sort_list:
    mov rcx, [rdi]
    cmp rcx, 0
    je .bye
    xor r10, r10
    mov r11, rsi
    .loop:
        cmp [rcx + 8], r10
        je .bye
        mov rdx, [rcx + 8]
        .loop2:
            cmp rdx, 0
            je .continue
            CALL_ r11, [rcx], [rdx]
            cmp rax, 0
            jg .swap
            .continue2:
            mov rdx, [rdx + 8]
            jmp .loop2
        .continue:
        mov rcx, [rcx + 8]
        jmp .loop
    .bye:
    xor rax, rax
    ret

    .swap:
        mov r8, [rcx]
        mov r9, [rdx]
        mov [rcx], r9
        mov [rdx], r8
        jmp .continue2

get_ptr:
    push rdi
    mov rdi, 8
    call my_malloc
    pop rdi
    mov qword [rax], rdi
    ret

add_in_sorted_list:
    push rdi
    mov rax, [rdi]
    push rax
    push rsi
    mov rax, 12
    mov rdi, 0
    syscall
    mov r10, rax

    mov rax, 12
    lea rdi, [r10 + 16]
    syscall
    pop r8
    mov [r10], r8
    pop r8
    mov [r10 + 8], r8
    pop rdi
    mov [rdi], r10
    CALL_ sort_list, rdi, rdx
    ret

merge:
    CALL_ concat_list, rdi, rsi
    CALL_ sort_list, rdi, rdx
    ret

my_malloc:
    cmp rdi, 0
    jle .malloc_error
    push rdi
    mov r10, qword [rel malloc_base]
    cmp r10, -1
    je .init_malloc_page
    .unprotect:
        mov rax, 10
        mov rdi, r10
        mov rsi, 4096
        mov rdx, 3
        syscall
        cmp rax, 0
        jl .malloc_error2
        cmp qword [r10], 0
        je .alloc
        mov r10, qword [r10]
        jmp .unprotect
    .alloc:
    pop rdi
    mov r8, rdi

    mov r10, qword [rel malloc_base]
    mov r11, -1
    .find_space:
        add r11, 17
        cmp r11, 4096
        jge .go_next_malloc_page
        cmp qword [r10 + r11], 0
        je .continue_find_space
        cmp byte [r10 + r11 + 16], 1
        je .find_space
        cmp qword [r10 + r11], r8
        jl .find_space
    .continue_find_space:
    cmp qword [r10 + r11], 0
    jne .split_malloc
    jmp .new_malloc

    .protect:
        mov r10, qword [rel malloc_base]
        .loop_protect:
            cmp r10, 0
            je .bye
            mov r8, qword [r10]
            mov rax, 10
            mov rdi, r10
            mov rsi, 4096
            mov rdx, 1
            syscall
            cmp rax, 0
            jl .malloc_error2
            mov r10, r8
            jmp .loop_protect
    .bye:
    pop rax
    ret

    .init_malloc_page:
        mov rax, 9
        mov rdi, 0
        mov rsi, 4096
        mov rdx, 3
        mov r10, 34
        mov r8, -1
        mov r9, 0
        syscall
        cmp rax, 0
        jl .malloc_error2

        mov qword [rel malloc_base], rax
        mov qword [rax], 0
        mov qword [rax + 8], 13
        mov qword [rax + 16], 0
        mov qword [rax + 24], 0
        mov byte [rax + 32], 0

        jmp .alloc

    .create_malloc_page:
        push r8
        push r10
        mov rax, 9
        mov rdi, 0
        mov rsi, 4096
        mov rdx, 3
        mov r10, 34
        mov r8, -1
        mov r9, 0
        syscall
        pop r10
        pop r8
        cmp rax, 0
        jl .malloc_error

        mov qword [r10], rax
        mov r10, rax
        mov qword [r10], 0
        mov qword [r10 + 8], 13
        mov qword [r10 + 16], 0
        mov qword [r10 + 24], 0
        mov byte [r10 + 32], 0

        mov r11, 16
        jmp .new_malloc
    
    .go_next_malloc_page:
        cmp qword [r10], 0
        je .create_malloc_page
        mov r10, qword [r10]
        mov r11, -1
        jmp .find_space

    .split_malloc:
        mov byte [r10 + r11 + 16], 1
        mov rdi, qword [r10 + r11 + 8]
        push rdi
        cmp qword [r10 + r11], r8
        je .protect
        mov rsi, qword [r10 + r11]
        sub rsi, r8
        mov qword[r10 + r11], r8
        push rsi
        .find_last_space:
            add r11, 17
            cmp r11, 4096
            jge .go_next_malloc_page2
            cmp qword [r10 + r11], 0
            jne .find_last_space
        .continue_split_malloc:
        pop rsi
        pop rdi
        push rdi
        add rdi, r8
        mov qword [r10 + r11], rsi
        mov qword [r10 + r11 + 8], rdi
        mov byte [r10 + r11 + 16], 0
        jmp .protect

    .create_malloc_page2:
        push r8
        push r10
        mov rax, 9
        mov rdi, 0
        mov rsi, 4096
        mov rdx, 3
        mov r10, 34
        mov r8, -1
        mov r9, 0
        syscall
        pop r10
        pop r8
        cmp rax, 0
        jl .malloc_error3

        mov qword [r10], rax
        mov r10, rax
        mov qword [r10], 0
        mov qword [r10 + 8], 13
        mov qword [r10 + 16], 0
        mov qword [r10 + 24], 0
        mov byte [r10 + 32], 0

        mov r11, 16
        jmp .continue_split_malloc
    
    .go_next_malloc_page2:
        cmp qword [r10], 0
        je .create_malloc_page2
        mov r10, qword [r10]
        mov r11, -1
        jmp .continue_split_malloc

    .new_malloc:
        push r8
        push r10
        push r11

        mov rax, 9
        mov rdi, 0
        mov rsi, r8
        mov rdx, 3
        mov r10, 34
        mov r8, -1
        mov r9, 0
        syscall

        mov r9, rax
        pop r11
        pop r10
        pop r8
        cmp rax, 0
        jl .malloc_error

        mov rax, r8
        xor rdx, rdx
        mov rbx, 4096
        div rbx
        sub rbx, rdx
        add rbx, r8

        mov qword [r10 + r11], rbx
        mov qword [r10 + r11 + 8], r9
        mov byte [r10 + r11 + 16], 0

        jmp .split_malloc

    .malloc_error:
        mov rax, 1
        mov rdi, 2
        lea rsi, [rel free_bug]
        mov rdx, 26
        syscall
        mov rax, 0
        ret
    
    .malloc_error2:
        pop rax
        jmp .malloc_error
    
    .malloc_error3:
        pop rax
        jmp .malloc_error2

my_free:
    cmp rdi, 0
    je .bye
    mov r10, qword [rel malloc_base]
    cmp r10, -1
    je .error_free
    push rdi
    .unprotect:
        mov rax, 10
        mov rdi, r10
        mov rsi, 4096
        mov rdx, 3
        syscall
        cmp rax, 0
        jl .bug_free2
        cmp qword [r10], 0
        je .dalloc
        mov r10, qword [r10]
        jmp .unprotect
        
    .dalloc:
    pop rdi

    mov r10, qword [rel malloc_base]
    mov r11, -1
    .find_malloc:
        add r11, 17
        cmp r11, 4096
        jge .go_next_malloc_page
        cmp qword [r10 + r11], 0
        je .error_free
        cmp qword [r10 + r11 + 8], rdi
        jne .find_malloc
    
    cmp byte [r10 + r11 + 16], 0
    je .error_free
    mov byte [r10 + r11 + 16], 0

    mov r8, r10
    add r8, r11
    mov r10, qword [rel malloc_base]
    mov r11, -1
    .find_free_prev:
        add r11, 17
        cmp r11, 4096
        jge .go_next_malloc_page_prev
        cmp qword [r10 + r11], 0
        je .leave_find_free_prev
        cmp byte [r10 + r11 + 16], 1
        je .find_free_prev
        mov r9, qword [r10 + r11 + 8]
        add r9, qword [r10 + r11]
        cmp qword [r8 + 8], r9
        jne .find_free_prev
        mov r9, qword [r8]
        add qword [r10 + r11], r9
        jmp .swap_prev

         .go_next_malloc_page_prev:
            cmp qword [r10], 0
            je .leave_find_free_prev
            mov r10, qword [r10]
            mov r11, -1
            jmp .find_free_prev

    .leave_find_free_prev:

    mov r10, qword [rel malloc_base]
    mov r11, -1
    mov r9, qword [r8 + 8]
    add r9, qword [r8]
    .find_free_next:
        add r11, 17
        cmp r11, 4096
        jge .go_next_malloc_page_next
        cmp qword [r10 + r11], 0
        je .leave_find_free_next
        cmp byte [r10 + r11 + 16], 1
        je .find_free_next
        cmp qword [r10 + r11 + 8], r9
        jne .find_free_next
        mov r9, qword [r10 + r11]
        add qword [r8], r9
        jmp .swap_next

         .go_next_malloc_page_next:
            cmp qword [r10], 0
            je .leave_find_free_next
            mov r10, qword [r10]
            mov r11, -1
            jmp .find_free_next

    .leave_find_free_next:

    .protect:
        mov r10, qword [rel malloc_base]
        .loop_protect:
            cmp r10, 0
            je .bye
            mov r8, qword [r10]
            mov rax, 10
            mov rdi, r10
            mov rsi, 4096
            mov rdx, 1
            syscall
            cmp rax, 0
            jl .bug_free
            mov r10, r8
            jmp .loop_protect

    .bye:
    ret

    .go_next_malloc_page:
        cmp qword [r10], 0
        je .error_free
        mov r10, qword [r10]
        mov r11, -1
        jmp .find_malloc

    .swap_prev:
        mov r9, r10
        add r9, r11
        push r9
        mov r10, qword [rel malloc_base]
        mov r11, -1
        mov r9, 0
        .find_last_prev:
            add r11, 17
            cmp r11, 4096
            jge .go_next_malloc_page_last_prev
            cmp qword [r10 + r11], 0
            je .leave_find_last_prev
            mov r9, r10
            add r9, r11
            jmp .find_last_prev
        .leave_find_last_prev:
        mov r10, r9
        pop r9
        mov rdx, qword [r10 + 8]
        cmp qword [r9 + 8], rdx
        je .prev_is_last
        mov rdx, qword [r10]
        mov qword [r8], rdx
        mov rdx, qword [r10 + 8]
        mov qword [r8 + 8], rdx
        mov dl, byte [r10 + 16]
        mov byte [r8 + 16], dl
        mov qword [r10], 0
        mov qword [r10 + 8], 0
        mov byte [r10 + 16], 0
        mov r8, r9
        jmp .leave_find_free_prev

        .go_next_malloc_page_last_prev:
            cmp qword [r10], 0
            je .leave_find_last_prev
            mov r10, qword [r10]
            mov r11, -1
            jmp .find_last_prev

        .prev_is_last:
            mov rdx, qword [r10]
            mov qword [r8], rdx
            mov rdx, qword [r10 + 8]
            mov qword [r8 + 8], rdx
            mov dl, byte [r10 + 16]
            mov byte [r8 + 16], dl
            mov qword [r10], 0
            mov qword [r10 + 8], 0
            mov byte [r10 + 16], 0
            jmp .leave_find_free_prev
        
    .swap_next:
        mov r9, r10
        add r9, r11
        push r9
        mov r10, qword [rel malloc_base]
        mov r11, -1
        mov r9, 0
        .find_last_next:
            add r11, 17
            cmp r11, 4096
            jge .go_next_malloc_page_last_next
            cmp qword [r10 + r11], 0
            je .leave_find_last_next
            mov r9, r10
            add r9, r11
            jmp .find_last_next
        .leave_find_last_next:
        mov r10, r9
        pop r9
        mov rdx, qword [r10]
        mov qword [r9], rdx
        mov rdx, qword [r10 + 8]
        mov qword [r9 + 8], rdx
        mov dl, byte [r10 + 16]
        mov byte [r9 + 16], dl
        mov qword [r10], 0
        mov qword [r10 + 8], 0
        mov byte [r10 + 16], 0
        jmp .leave_find_free_next

        .go_next_malloc_page_last_next:
            cmp qword [r10], 0
            je .leave_find_last_next
            mov r10, qword [r10]
            mov r11, -1
            jmp .find_last_next

    .error_free:
        mov rax, 1
        mov rdi, 2
        lea rsi, [rel free_error]
        mov rdx, 24
        syscall
        mov rax, 39
        syscall
        mov rdi, rax
        mov rsi, 6
        mov rax, 62
        syscall
        ret
    
    .bug_free:
        mov rax, 1
        mov rdi, 2
        lea rsi, [rel free_bug]
        mov rdx, 26
        syscall
        mov rax, 39
        syscall
        mov rdi, rax
        mov rsi, 6
        mov rax, 62
        syscall
        ret

    .bug_free2:
        pop rax
        jmp .bug_free

my_calloc:
    push rdi
    push rsi
    call my_malloc
    pop rsi
    pop rdi
    mov rcx, 0
    .loop_calloc:
        mov byte [rax + rcx], sil
        inc rcx
        cmp rcx, rdi
        jne .loop_calloc
    ret

my_realloc:
    push rsi
    cmp rdi, 0
    jne .free
    .back_free:
    pop rdi
    cmp rdi, 0
    jne .malloc
    .back_malloc:
    ret

    .free:
        call my_free
        jmp .back_free

    .malloc:
        call my_malloc
        jmp .back_malloc

show_malloc:
    CALL_ my_putchar, 'g'
    CALL_ my_putchar, 'o'
    CALL_ my_putchar, 10
    mov r10, qword [rel malloc_base]
    cmp r10, -1
    je .bye
    .unprotect:
        mov rax, 10
        mov rdi, r10
        mov rsi, 4096
        mov rdx, 3
        syscall
        cmp rax, 0
        jl .bye
        cmp qword [r10], 0
        je .alloc
        mov r10, qword [r10]
        jmp .unprotect
    .alloc:

    mov r10, qword [rel malloc_base]
    mov r11, -1
    .find_space:
        add r11, 17
        cmp r11, 4096
        jge .go_next_malloc_page
        cmp qword[r10 + r11], 0
        je .continue_find_space
        xor rdi, rdi
        mov rdi, qword[r10 + r11]
        CALL_ my_putchar, 's'
        CALL_ my_putchar, ':'
        CALL_ my_putnbr, rdi
        CALL_ my_putchar, 32
        xor rdi, rdi
        mov rdi, qword[r10 + r11 + 8]
        CALL_ my_putchar, 'a'
        CALL_ my_putchar, ':'
        CALL_ my_putnbr, rdi
        CALL_ my_putchar, 32
        xor rdi, rdi
        movzx rdi, byte[r10 + r11 + 16]
        CALL_ my_putchar, 'e'
        CALL_ my_putchar, ':'
        CALL_ my_putnbr, rdi
        CALL_ my_putchar, 10
        jmp .find_space
    .continue_find_space:

    .protect:
        mov r10, qword [rel malloc_base]
        .loop_protect:
            cmp r10, 0
            je .bye
            mov r8, qword [r10]
            mov rax, 10
            mov rdi, r10
            mov rsi, 4096
            mov rdx, 1
            syscall
            cmp rax, 0
            jl .bye
            mov r10, r8
            jmp .loop_protect
    .bye:
    ret

    .go_next_malloc_page:
        cmp qword [r10], 0
        je .bye
        CALL_ my_putchar, 'n'
        CALL_ my_putchar, 'p'
        CALL_ my_putchar, 10
        mov r10, qword [r10]
        mov r11, -1
        jmp .find_space

futex_lock:
    mov rax, 1
    xchg byte[rdi], al
    cmp rax, 0
    je .bye
    .loop:
        mov rax, 2
        xchg byte[rdi], al
        cmp rax, 0
        je .bye
        mov rax, 202
        mov rdi, rdi
        mov rsi, 0
        mov rdx, 2
        mov r10, 0
        mov r8, 0
        syscall
        jmp .loop
    .bye:
        ret

futex_unlock:
    mov rax, rsi
    neg rax
    lock xadd byte[rdi], al
    cmp rax, 1
    je .bye
    mov rax, 0
    xchg byte[rdi], al
    mov rax, 202
    mov rdi, rdi
    mov rsi, 1
    mov rdx, 1
    mov r10, 0
    mov r8, 0
    syscall
    .bye:
        ret
