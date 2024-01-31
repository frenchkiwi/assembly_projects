section .data
    x1_value db 48
    y1_value db 47
    space db 32
    x2_value db 48
    y2_value db 48
    again db ", "

section .text
    global _start

write_info:
    mov rax, 1
    mov rdi, 1
    mov rdx, 1

    mov rsi, x1_value
    syscall

    mov rsi, y1_value
    syscall

    mov rsi, space
    syscall

    mov rsi, x2_value
    syscall

    mov rsi, y2_value
    syscall

    ret

write_again:
    mov rax, 1
    mov rdi, 1
    mov rsi, again
    mov rdx, 2
    syscall
    ret

check_end:
    cmp byte [y2_value], 57
    je check_x2
    ret
    check_x2:
        cmp byte [x2_value], 57
        je check_y1
        ret
    check_y1:
        cmp byte [y1_value], 56
        je check_x1
        ret
    check_x1:
        cmp byte [x1_value], 57
        je _exit
        ret

up:
    inc r9b
    cmp r9b, 58
    je up2
    ret
    up2:
        inc r8b
        mov r9b, 48
        ret


_start:
    main_loop:
        mov r8b, byte [x1_value]
        mov r9b, byte [y1_value]
        call up
        mov byte [x1_value], r8b
        mov byte [y1_value], r9b

        mov r8b, byte [x1_value]
        mov byte [x2_value], r8b

        mov r8b, byte [y1_value]
        mov byte [y2_value], r8b


        secondary_loop:
            mov r8b, byte [x2_value]
            mov r9b, byte [y2_value]
            call up
            mov byte [x2_value], r8b
            mov byte [y2_value], r9b

            call write_info
            call check_end
            call write_again

            cmp byte [x2_value], 57
            jne secondary_loop
            cmp byte [y2_value], 57
            jne secondary_loop

    jmp main_loop
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
                
