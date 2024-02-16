%ifndef MACRO_
    %define MACRO_
    %macro ABS 1
        cmp %1, 0
        jge %%bye_ABS
        neg %1
        %%bye_ABS:
    %endmacro

    %macro CALL_ 1-7
        push rdi ; -prologue-
        push rsi ;
        push rdx ;
        push rcx ;
        push r8 ;
        push r9 ;
        push r10 ;
        push r11 ; ----------
        %if %0 >= 2 ; check if there is 1st param
            mov rdi, %2 ; set 1st param
            %if %0 >= 3 ; check if there is 2nd param
                %rotate 1 ; move to 2nd param
                mov rsi, %2 ; set 2nd param
                %if %0 >= 4 ; check if there is 3rd param
                    %rotate 1 ; move to 3rd param
                    mov rdx, %2 ; set 3rd param
                    %if %0 >= 5 ; check if there is 4th param
                        %rotate 1 ; move to 4th param
                        mov rcx, %2 ; set 4th param
                        %if %0 >= 6 ; check if there is 5th param
                            %rotate 1 ; move to 5th param
                            mov r8, %2 ; set 5th param
                            %if %0 == 7 ; check if there is 6th param
                                %rotate 1 ; move to 6th param
                                mov r9, %2 ; set 6th param
                            %endif
                        %endif
                    %endif
                %endif
            %endif
        %endif
        %rotate 2 ; move to function

        call %1 ; call function

        pop r11 ; -epilogue-
        pop r10 ;
        pop r9 ;
        pop r8 ;
        pop rcx ;
        pop rdx ;
        pop rsi ;
        pop rdi ; ----------
    %endmacro
%endif

section .text
    global my_putchar
    global my_putcharerror
    global my_putnbr
    global my_swap
    global my_strlen
    global my_putstr
    global my_puterror
    global my_revstr
    global my_getnbr
    global my_sort_int_array
    global my_compute_factorial_it
    global my_compute_factorial_rec
    global my_compute_power_it
    global my_compute_power_rec
    global my_compute_square_root
    global my_is_prime
    global my_is_prime_sup
    global my_strcpy
    global my_strncpy
    global my_strstr
    global my_strcmp
    global my_strncmp
    global my_strupcase
    global my_strdowncase
    global my_strcapitalize
    global my_str_isalpha
    global my_str_isnum
    global my_str_islower
    global my_str_isupper
    global my_str_isprintable
    global my_putnbr_base
    global my_getnbr_base
    global my_showstr
    global my_showmem
    global my_strcat
    global my_strncat
    global my_strdup
    global my_show_word_array
    global my_str_to_word_array
    global my_sort_word_array
    global my_advanced_sort_word_array
    global my_list_size
    global my_rev_list
    global my_apply_to_nodes
    global my_apply_to_matching_nodes
    global my_find_node
    global my_delete_nodes
    global my_concat_list
    global my_sort_list
    global get_ptr
    global my_add_in_sorted_list
    global my_merge

my_putchar:
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
    mov rdi, 1
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
        .loop_putnbr_len:
            inc r11

            mov rdi, 10
            mov rsi, r11
            call my_compute_power_it

            mov rbx, rax
            mov rax, r8
            xor rdx, rdx
            div rbx

            cmp rax, 1
            jge .loop_putnbr_len
        
        .loop_putnbr:
            dec r11

            mov rdi, 10
            mov rsi, r11
            call my_compute_power_it
            mov rbx, rax
            mov rax, r8
            xor rdx, rdx
            div rbx

            mov r8, rdx
            add rax, '0'
            CALL_ my_putchar, rax

            cmp r11, 0
            jne .loop_putnbr
        xor rax, rax
        ret

my_swap:
    xchg rdi, rsi
    ret

my_strlen:
    mov rax, -1
    .loop_strlen:
        inc rax
        cmp byte [rdi + rax], 0
        jne .loop_strlen
    ret

my_putstr:
    cmp rdi, 0
    je .bye_putstr
    mov rsi, rdi
    mov rdx, -1
    .loop_putstr:
        inc rdx
        cmp byte [rsi + rdx], 0
        jne .loop_putstr
    mov rax, 1
    mov rdi, 1
    syscall
    .bye_putstr:
        mov rax, 0
        ret

my_puterror:
    cmp rdi, 0
    je .bye_putstr
    mov rsi, rdi
    mov rdx, -1
    .loop_putstr:
        inc rdx
        cmp byte [rsi + rdx], 0
        jne .loop_putstr
    mov rax, 1
    mov rdi, 2
    syscall
    .bye_putstr:
        mov rax, 0
        ret

my_revstr:
    mov rcx, -1
    .loop_revstr:
        inc rcx
        cmp byte [rdi + rcx], 0
        jne .loop_revstr
    
    mov rax, rcx
    xor rdx, rdx
    mov rbx, 2
    div rbx
    xchg rax, rcx

    mov rbx, 0
    .loop_revstr2:
        dec rax
        mov r8b, byte [rdi + rbx]
        mov r9b, byte [rdi + rax]
        mov byte [rdi + rbx], r9b
        mov byte [rdi + rax], r8b
        inc rbx
        loop .loop_revstr2
    mov rax, rdi
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

my_sort_int_array:
    mov rcx, 0
    .loop_sort_int_array:
        cmp rcx, rsi
        je .bye_sort_int_array
        mov rdx, rcx
        .loop_sort_int_array2:
            inc rdx
            mov r8d, dword [rdi + rdx * 4]
            cmp dword [rdi + rcx * 4], r8d
            jg .swap_sort_int_array
            .back_up_sort_int_array:
                cmp rdx, rsi
                jne .loop_sort_int_array2
        inc rcx
        jmp .loop_sort_int_array
    
    .swap_sort_int_array:
        mov r8d, dword [rdi + rcx * 4]
        mov r9d, dword [rdi + rdx * 4]
        mov dword [rdi + rcx * 4], r9d
        mov dword [rdi + rdx * 4], r8d
        jmp .back_up_sort_int_array
    
    .bye_sort_int_array:
        ret

my_compute_factorial_it:
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

my_compute_power_it:
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

my_is_prime:
    cmp rdi, 1
    jle .zero_prime

    mov rax, rdi
    xor rdx, rdx
    mov rbx, 2
    div rbx

    cmp rdi, 2
    je .one_prime

    cmp rdx, 0
    je .zero_prime

    mov r8, rax
    .loop_prime:
        inc rbx
        cmp rbx, r8
        jge .one_prime

        mov rax, rdi
        xor rdx, rdx
        div rbx

        cmp rdx, 0
        je .zero_prime
        jmp .loop_prime

    .one_prime:
        mov rax, 1
        ret
    .zero_prime:
        mov rax, 0
        ret

my_find_prime_sup:
    cmp rdi, 1
    jle .zero_prime_sup

    mov rax, rdi
    xor rdx, rdx
    mov rbx, 2
    div rbx

    cmp rdi, 2
    je .one_prime_sup

    cmp rdx, 0
    je .zero_prime_sup

    mov r8, rax
    .loop_prime_sup:
        inc rbx
        cmp rbx, r8
        jge .one_prime_sup

        mov rax, rdi
        xor rdx, rdx
        div rbx

        cmp rdx, 0
        je .zero_prime_sup
        jmp .loop_prime_sup

    .one_prime_sup:
        mov rax, rdi
        ret
    .zero_prime_sup:
        inc rdi
        call my_find_prime_sup
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
    .loop_strstrlen:
        inc r8
        cmp byte [rsi + r8], 0
        jne .loop_strstrlen
    mov rdx, -1
    mov rcx, -1
    .loop_my_strstr:
        inc rdx
        inc rcx
        cmp rcx, r8
        je  .bye_strstr
        mov r9b, byte [rsi + rcx]
        cmp byte [rdi + rdx], r9b
        jne .reset_and_again_my_strstr
        .again_loop_my_strstr:
            cmp byte [rdi + rdx], 0
            jne .loop_my_strstr
    mov rax, 0
    ret

    .reset_and_again_my_strstr:
        mov rcx, -1
        jmp .again_loop_my_strstr

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
    dec rdx
    cmp rdx, 0
    jl .bye_strncmp
    .loop_strncmp:
        inc rcx
        cmp rcx, rdx
        je .bye_strncmp2
        mov r9b, byte [rsi + rcx]
        cmp byte [rdi + rcx], r9b
        jne .bye_strncmp2
        cmp byte [rdi + rcx], 0
        jne .loop_strncmp
    
    .bye_strncmp:
    mov rax, 0
    ret

    .bye_strncmp2:
        mov al, byte [rsi + rcx]
        sub al, byte [rdi + rcx]
        ret

my_strupcase:
    mov rcx, -1
    .loop_strupcase:
        inc rcx
        cmp byte [rdi + rcx], 'a'
        jl .again_loop_strupcase
        cmp byte [rdi + rcx], 'z'
        jg .again_loop_strupcase
        sub byte [rdi + rcx], 32
        .again_loop_strupcase:
            cmp byte [rdi + rcx], 0
            jne .loop_strupcase
    mov rax, rdi
    ret

my_strdowncase:
    mov rcx, -1
    .loop_strdowncase:
        inc rcx
        cmp byte [rdi + rcx], 'A'
        jl .again_loop_strdowncase
        cmp byte [rdi + rcx], 'Z'
        jg .again_loop_strdowncase
        add byte [rdi + rcx], 32
        .again_loop_strdowncase:
            cmp byte [rdi + rcx], 0
            jne .loop_strdowncase
    mov rax, rdi
    ret

my_strcapitalize:
    mov rcx, -1
    mov rdx, 1
    .loop_strcapitalize:
.        inc rcx
        call .down_strcapitalize
        .again_loop_strcapitalize:
            cmp byte [rdi + rcx], 0
            jne .loop_strcapitalize
    mov rax, rdi
    ret

    .down_strcapitalize:
        cmp byte [rdi + rcx], 'A'
        jl .up_strcapitalize
        cmp byte [rdi + rcx], 'Z'
        jg .up_strcapitalize
        add byte [rdi + rcx], 32
        jmp .up_strcapitalize

    .up_strcapitalize:
        cmp rdx, 0
        je .check_strcapitalize
        cmp byte [rdi + rcx], 'a'
        jl .check_strcapitalize
        cmp byte [rdi + rcx], 'z'
        jg .check_strcapitalize
        sub byte [rdi + rcx], 32
        mov rdx, 0
        jmp .check_strcapitalize

    .check_strcapitalize:
        cmp byte [rdi + rcx], 'A'
        jl .is_capitalize
        cmp byte [rdi + rcx], 'z'
        jg .is_capitalize
        jmp .check_strcapitalize2

    .check_strcapitalize2:
        cmp byte [rdi + rcx], 'Z'
        jle .again_loop_strcapitalize
        cmp byte [rdi + rcx], 'a'
        jge .again_loop_strcapitalize
        jmp .is_capitalize

    .is_capitalize:
        mov rdx, 1
        jmp .again_loop_strcapitalize

my_str_isalpha:
    mov rcx, -1
    .loop_isalpha:
        inc rcx
        cmp byte [rdi + rcx], 0
        je .one_isalpha
        jmp .check_isalpha

    .check_isalpha:
        cmp byte [rdi + rcx], 'A'
        jl .zero_isalpha
        cmp byte [rdi + rcx], 'z'
        jg .zero_isalpha
        jmp .check_isalpha2

    .check_isalpha2:
        cmp byte [rdi + rcx], 'Z'
        jle .loop_isalpha
        cmp byte [rdi + rcx], 'a'
        jge .loop_isalpha
        jmp .zero_isalpha

    .zero_isalpha:
        mov rax, 0 
        ret
    
    .one_isalpha:
        mov rax, 1
        ret

my_str_isnum:
    mov rcx, -1
    .loop_isnum:
        inc rcx
        cmp byte [rdi + rcx], 0
        je .one_isnum
        jmp .check_isnum

    .check_isnum:
        cmp byte [rdi + rcx], '0'
        jl .zero_isnum
        cmp byte [rdi + rcx], '9'
        jg .zero_isnum
        jmp .loop_isnum

    .zero_isnum:
        mov rax, 0 
        ret
    
    .one_isnum:
        mov rax, 1
        ret

my_str_islower:
    mov rcx, -1
    .loop_islower:
        inc rcx
        cmp byte [rdi + rcx], 0
        je .one_islower
        jmp .check_islower

    .check_islower:
        cmp byte [rdi + rcx], 'a'
        jl .zero_islower
        cmp byte [rdi + rcx], 'z'
        jg .zero_islower
        jmp .loop_islower

    .zero_islower:
        mov rax, 0 
        ret
    
    .one_islower:
        mov rax, 1
        ret

my_str_isupper:
    mov rcx, -1
    .loop_isupper:
        inc rcx
        cmp byte [rdi + rcx], 0
        je .one_isupper
        jmp .check_isupper

    .check_isupper:
        cmp byte [rdi + rcx], 'A'
        jl .zero_isupper
        cmp byte [rdi + rcx], 'Z'
        jg .zero_isupper
        jmp .loop_isupper

    .zero_isupper:
        mov rax, 0 
        ret
    
    .one_isupper:
        mov rax, 1
        ret

my_str_isprintable:
    mov rcx, -1
    .loop_isprintable:
        inc rcx
        cmp byte [rdi + rcx], 0
        je .one_isprintable
        jmp .check_isprintable

    .check_isprintable:
        cmp byte [rdi + rcx], ' '
        jl .zero_isprintable
        cmp byte [rdi + rcx], '~'
        jg .zero_isprintable
        jmp .loop_isprintable

    .zero_isprintable:
        mov rax, 0 
        ret
    
    .one_isprintable:
        mov rax, 1
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
        .loop_putnbr_base_len2:
            inc r10
            cmp byte [r9 + r10], 0
            jne .loop_putnbr_base_len2

        mov r11, 0
        .loop_putnbr_base_len:
            inc r11

            mov rdi, r10
            mov rsi, r11
            call my_compute_power_it

            mov rbx, rax
            mov rax, r8
            xor rdx, rdx
            div rbx

            cmp rax, 1
            jge .loop_putnbr_base_len


        .loop_putnbr_base:
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
            jne .loop_putnbr_base
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
        call my_compute_power_it

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
    mov r8, rdi
    mov rax, 12
    mov rdi, 0
    syscall
    mov r9, rax
    
    mov rdi, r8
    call my_strlen
    
    inc rax
    lea rdi, [r9 + rax]
    mov rax, 12
    syscall

    mov rcx, -1
    .loop_strdup:
        inc rcx
        movzx r10, byte [r8 + rcx]
        mov byte [r9 + rcx], r10b
        cmp byte [r8 + rcx], 0
        jne .loop_strdup
    mov rax, r9
    ret 

my_show_word_array:
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

my_str_to_word_array:
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

my_sort_word_array:
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

my_advanced_sort_word_array:
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

my_list_size:
    mov rcx, -1
    mov rax, rdi
    .loop:
        inc rcx
        cmp rax, 0
        je .bye
        mov rax, [rax + 8]
        jmp .loop
    .bye:
    mov rax, rcx
    ret

my_rev_list:
    cmp rdi, 0
    je .bye
    mov rdx, rdi
    .loop:
        cmp qword [rdi + 8], 0
        je .continue
        mov rdi, [rdi + 8]
        jmp .loop
    .continue:
    mov rax, rdi
    .loop2:
        mov rsi, rdx
        .loop3:
            cmp qword [rsi + 8], rax
            je .add_next
            mov rsi, [rsi + 8]
            jmp .loop3
        .add_next:
        mov [rax + 8], rsi
        mov rax, [rax + 8]
        cmp rsi, rdx
        jne .loop2
    mov rsi, 0
    mov [rax + 8], rsi
    .bye:
    ret

my_apply_to_nodes:
    mov r8, rdi
    .loop:
        cmp r8, 0
        je .bye
        CALL_ rsi, [r8]
        mov r8, [r8 + 8]
        jmp .loop
    .bye:
    mov rax, 0
    ret

my_apply_to_matching_nodes:
    mov r8, rdi
    .loop:
        cmp r8, 0
        je .bye
        CALL_ rcx, [r8], rdx
        cmp rax, 0
        jne .continue
        CALL_ rsi, [r8]
        .continue:
        mov r8, [r8 + 8]
        jmp .loop
    .bye:
    mov rax, 0
    ret

my_find_node:
    mov r8, rdi
    .loop:
        cmp r8, 0
        je .bye
        CALL_ rdx, [r8], rsi
        cmp rax, 0
        jne .continue
        mov rax, r8
        ret
        .continue:
        mov r8, [r8 + 8]
        jmp .loop
    .bye:
    mov rax, 0
    ret

my_delete_nodes:
    mov r8, [rdi]
    .loop:
        cmp r8, 0
        je .bye
        cmp r8, [rdi]
        je .first_node
        CALL_ rdx, [r8], rsi
        cmp rax, 0
        je .continue
        mov [r9 + 8], r8
        mov r9, [r9 + 8]
        .continue:
        mov r8, [r8 + 8]
        jmp .loop
    .bye:
    mov r11, [rdi]
    cmp r11, 0
    je .bye2
    mov [r9 + 8], r8
    .bye2:
    mov rax, 0
    ret

    .first_node:
        CALL_ rdx, [r8], rsi
        cmp rax, 0
        je .move_begin
        mov r9, r8
        jmp .continue
        .move_begin:
            mov r11, [r8 + 8]
            mov [rdi], r11
            jmp .continue

my_concat_list:
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

my_sort_list:
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
    mov rax, 12
    mov rdi, 0
    syscall
    mov r8, rax

    mov rax, 12
    lea rdi, [r8 + 16]
    syscall
    pop rdi
    mov qword [r8], rdi
    mov rax, r8
    ret

my_add_in_sorted_list:
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
    CALL_ my_sort_list, rdi, rdx
    ret

my_merge:
    CALL_ my_concat_list, rdi, rsi
    CALL_ my_sort_list, rdi, rdx
    ret
