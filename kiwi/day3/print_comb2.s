.global _start
.intel_syntax noprefix

.data
    i: .long '0'
    j: .long '0'
    x: .long '0'
    y: .long '0'
    next: .asciz ", "
    space: .long ' '

.text
    _start:
        mov rax, 0
        jmp main_loop

    write_all:
        mov rax, 1
        mov rdi, 1
        mov rdx, 1
        lea rsi, [i]
        syscall
        lea rsi, [j]
        syscall
        lea rsi, [space]
        syscall
        lea rsi, [x]
        syscall
        lea rsi, [y]
        syscall
        ret

    write_space:
        mov rax, 1
        mov rdi, 1
        mov rdx, 2
        lea rsi, [next]
        syscall
        ret

    bye:
        ret

    send_end:
        mov r8d, [i]
        mov r9d, [j]
        cmp r8d, '9'
        jl bye
        cmp r9d, '8'
        jl bye
        jmp end
    
    x_up:
        sub r11d, 9
        mov [y], r11d
        add r10d, 1
        mov [x], r10d
        ret

    up_right:
        mov r10d, [i]
        mov r11d, [y]
        cmp r11d, '9'
        jge x_up
        add r11d, 1
        mov [y], r11d
        ret

    i_up:
        sub r9d, 9
        mov [j], r9d
        add r8d, 1
        mov [i], r8d
        ret

    up_left:
        cmp r9d, '9'
        jge i_up
        add r9d, 1
        mov [j], r9d
        ret

    check_loop:
        cmp r11d, '9'
        jge bye
        cmp r10d, '9'
        jge bye
        mov rax, 1
        ret

    main_loop:
        mov r8d, [i]
        mov r9d, [j]
        mov [x], r8d
        add r9d, 1
        mov [y], r9d
        secondary_loop:
            call write_all
            call up_right
            call check_loop
            cmp rax, 1
            jne secondary_loop
        mov rax, 0
        call send_end
        call write_space
        call up_left
        jmp main_loop
 
    end:
        mov rax, 60
        mov rdi, 0
        syscall
