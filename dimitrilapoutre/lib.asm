my_swap:
    xchg rdi, rsi
    ret

my_strlen:
    mov rax, -1
    loop_strlen:
        inc rax
        cmp byte [rdi + rax], 0
        jne loop_strlen
    ret

my_putstr:
    mov rsi, rdi
    mov rdx, -1
    loop_putstr:
        inc rdx
        cmp byte [rsi + rdx], 0
        jne loop_putstr
    mov rax, 1
    mov rdi, 1
    syscall
    ret

my_evil_str:
    mov rcx, -1
    loop_evil_str:
        inc rcx
        cmp byte [rdi + rcx], 0
        jne loop_evil_str
    
    mov rax, rcx
    xor rdx, rdx
    mov rbx, 2
    div rbx
    xchg rax, rcx

    mov rbx, 0
    loop_evil_str2:
        dec rax
        mov r8b, byte [rdi + rbx]
        mov r9b, byte [rdi + rax]
        mov byte [rdi + rbx], r9b
        mov byte [rdi + rax], r8b
        inc rbx
        loop loop_evil_str2
    mov rax, rdi
    ret

my_getnbr:
    mov r8, 1
    mov r9, 0
    mov rax, 0
    mov rcx, -1
    loop_getnbr:
        cmp rax, 2147483647
        jg zero
        cmp rax, -2147483648
        jl zero
        inc rcx
        cmp byte [rdi + rcx], 45
        je neg
        cmp byte [rdi + rcx], 43
        je pos
        cmp byte [rdi + rcx], 48
        jl bye
        cmp byte [rdi + rcx], 57
        jg bye
        
        mov r9, 1
        mov rdx, 10
        mul rdx

        movzx rbx, byte [rdi + rcx]
        sub bl, 48
        add rax, rbx
        jmp loop_getnbr

    zero:
        mov rax, 0
        ret

    pos:
        cmp r9, 0
        jne bye
        jmp loop_getnbr

    neg:
        cmp r9, 0
        jne bye
        neg r8
        jmp loop_getnbr

    bye:
        cmp r8, 1
        je bye2
        neg rax
        bye2:
            ret

my_sort_int_array:
    mov rcx, 0
    loop_sort_int_array:
        cmp rcx, rsi
        je bye_sort_int_array
        mov rdx, rcx
        loop_sort_int_array2:
            inc rdx
            mov r8d, dword [rdi + rdx * 4]
            cmp dword [rdi + rcx * 4], r8d
            jg swap_sort_int_array
            back_up_sort_int_array:
                cmp rdx, rsi
                jne loop_sort_int_array2
        inc rcx
        jmp loop_sort_int_array
    
    swap_sort_int_array:
        mov r8d, dword [rdi + rcx * 4]
        mov r9d, dword [rdi + rdx * 4]
        mov dword [rdi + rcx * 4], r9d
        mov dword [rdi + rdx * 4], r8d
        jmp back_up_sort_int_array
    
    bye_sort_int_array:
        ret

my_compute_factorial_it:
    mov rax, 1
    mov rcx, 0
    cmp rdi, 0
    jl error_factorial_it
    loop_factorial_it:
        inc rcx
        cmp rcx, rdi
        jg bye_factorial_it
        
        mov rdx, rcx
        mul rdx

        jmp loop_factorial_it

    bye_factorial_it:
        ret

    error_factorial_it:
        mov rax, -1
        ret

my_compute_factorial_rec:
    pop rsi
    pop rdi
    push rdi
    push rsi
    cmp rdi, 0
    jl error_factorial_rec

    cmp rdi, 0
    je bye_factorial_rec2

    dec rdi
    push rdi
    call my_compute_factorial_rec
    
    pop rsi
    pop rdi
    push rsi
    mul rdi

    bye_factorial_rec:
        ret

    bye_factorial_rec2:
        pop rsi
        pop rdi
        push rsi
        mov rax, 1
        ret

    error_factorial_rec:
        mov rax, -1
        ret

my_compute_power_it:
    cmp rsi, 0
    jl neg_power_it
    cmp rsi, 0
    je zero_power_it

    mov rax, 1
    loop_power_it:
        dec rsi

        mul rdi

        cmp rsi, 0
        jne loop_power_it
    ret

    zero_power_it:
        mov rax, 1
        ret
    
    neg_power_it:
        mov rax, 0
        ret

my_compute_power_rec:
    pop rdx
    pop rsi
    pop rdi
    push rdi
    push rsi
    push rdx

    cmp rsi, 0
    jl neg_power_rec
    cmp rsi, 0
    je zero_power_rec

    dec rsi
    push rdi
    push rsi
    call my_compute_power_rec
    pop rsi
    pop rdi

    mul rdi
    ret

    zero_power_rec:
        mov rax, 1
        ret
    
    neg_power_rec:
        mov rax, 0
        ret

my_is_prime:
    cmp rdi, 1
    jle zero_prime

    mov rax, rdi
    xor rdx, rdx
    mov rbx, 2
    div rbx

    cmp rdi, 2
    je one_prime

    cmp rdx, 0
    je zero_prime

    mov r8, rax
    loop_prime:
        inc rbx
        cmp rbx, r8
        jge one_prime

        mov rax, rdi
        xor rdx, rdx
        div rbx

        cmp rdx, 0
        je zero_prime
        jmp loop_prime

    one_prime:
        mov rax, 1
        ret
    zero_prime:
        mov rax, 0
        ret
