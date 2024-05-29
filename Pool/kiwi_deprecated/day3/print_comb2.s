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
        mov r12d, 0
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

    up:
        cmp r9d, '9'
        je up_left
        add r9d, 1
        ret
        up_left:
            mov r9d, '0'
            add r8d, 1
            ret

    check_loop:
        mov r11d, [y]
        mov r10d, [x]
        cmp r11d, '9'
        jl bye
        cmp r10d, '9'
        jl bye
        mov r12d, 1
        ret

    main_loop:
        mov r8d, [i]
        mov r9d, [j]
        mov [x], r8d
        mov [y], r9d
        secondary_loop:
            mov r8d, [x]
            mov r9d, [y]
            call up
            mov [x], r8d
            mov [y], r9d
            call write_all
            call send_end
            call write_space
            call check_loop
            cmp r12d, 1
            jne secondary_loop
        mov r12d, 0
        mov r8d, [i]
        mov r9d, [j]
        call up
        mov [i], r8d
        mov [j], r9d
        jmp main_loop
 
    end:
        mov rdi, 0
        mov rax, 60
        syscall

    _error:
        mov rdi, r11
        mov rax, 60
        syscall
