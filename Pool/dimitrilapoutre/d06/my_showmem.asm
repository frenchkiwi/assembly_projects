section .data
    string db "hey guys show mem is cool you can do some pretty neat stuff", 0
section .text
    extern my_compute_power_it
    global _start

my_showmem:
    mov r8, rdi
    mov r9, rsi
    mov r10, -1
    loop_showmem:
        mov rcx, 8
        inc r10
        push r10
        call print_adress_showmem

        pop r10
        dec r10
        
        loop_showmem2:
            inc r10

            mov rax, r10
            xor rdx, rdx
            mov rbx, 16
            div rbx

            call print_hexa_showmem

            push rdx
            mov rax, rdx
            xor rdx, rdx
            mov rbx, 2
            div rbx

            call need_space_showmem
            pop rdx

            cmp rdx, 15
            jne loop_showmem2
        sub r10, 16
        loop_showmem3:
            inc r10
            
            cmp r10, r9
            je print_newline_showmem

            mov rax, r10
            xor rdx, rdx
            mov rbx, 16
            div rbx

            call print_showmem

            cmp rdx, 15
            jne loop_showmem3
        print_newline_showmem:
            mov bl, byte [r8]
            mov rax, 1
            mov rdi, 1
            mov byte [r8], 10
            lea rsi, [r8]
            mov rdx, 1
            syscall
            mov byte [r8], bl

            cmp r10, r9
            je bye_showmem
            dec r9
            cmp r10, r9
            je bye_showmem
            inc r9

            jmp loop_showmem

    bye_showmem:
        mov rax, 0
        ret

    print_adress_showmem:
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
        jl print_adress_part_showmem
        add byte [r8], 39
        print_adress_part_showmem:
            push rcx
            mov rax, 1
            mov rdi, 1
            lea rsi, [r8]
            mov rdx, 1
            syscall
            mov byte [r8], bl
            pop rcx

        cmp rcx, 0
        jne print_adress_showmem
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

    print_hexa_showmem:
        push rdx

        mov rax, 1
        mov rdi, 1
        mov rdx, 1

        cmp r10, r9
        jge print_hexa_empty_showmem
        
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
        call is_hexa_showmem
        mov byte [r8], r10b
        lea rsi, [r8]
        mov r10, r11
        syscall
        call is_hexa_showmem
        mov byte [r8], r10b
        lea rsi, [r8]
        syscall
        mov byte [r8], bl
        pop r10

        pop rdx
        ret

        is_hexa_showmem:
            cmp r10, 58
            jl bye_is_hexa_showmem
            add r10, 39
            bye_is_hexa_showmem:
                ret
        
        print_hexa_empty_showmem:
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

    need_space_showmem:
        cmp rdx, 1
        je print_space_showmem
        ret

        print_space_showmem:
            mov bl, byte [r8]
            mov rax, 1
            mov rdi, 1
            mov byte [r8], 32
            lea rsi, [r8]
            mov rdx, 1
            syscall
            mov byte [r8], bl
            ret

    print_showmem:
        push rdx
        cmp byte [r8 + r10], ' '
        jl print_dot_showmem
        cmp byte [r8 + r10], '~'
        jg print_dot_showmem

        mov rax, 1
        mov rdi, 1
        lea rsi, [r8 + r10]
        mov rdx, 1
        syscall

        bye_print_showmem:
            pop rdx
            ret 
        print_dot_showmem:
            mov bl, byte [r8]
            mov rax, 1
            mov rdi, 1
            mov byte [r8], 46
            lea rsi, [r8]
            mov rdx, 1
            syscall
            mov byte [r8], bl
            jmp bye_print_showmem

_start:
    mov rdi, string
    mov rsi, 79
    call my_showmem
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
