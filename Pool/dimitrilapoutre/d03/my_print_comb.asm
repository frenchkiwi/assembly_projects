section .data
    x_value db 48
    y_value db 48
    z_value db 48
    again db ", "

section .text
    global _start

write:
    mov rax, 1
    mov rdi, 1
    mov rsi, x_value
    mov rdx, 1
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, y_value
    mov rdx, 1
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, z_value
    mov rdx, 1
    syscall
    ret

write_again:
    mov rax, 1
    mov rdi, 1
    mov rsi, again
    mov rdx, 2
    syscall
    ret

check_z:
    cmp byte [z_value], 57
    je check_y
    ret
    check_y:
        cmp byte [y_value], 56
        je check_x
        ret
    check_x:
        cmp byte [x_value], 55
        je _exit
        ret

_start:
    x_loop:
        mov r8b, byte [x_value]
        inc r8b
        mov byte [y_value], r8b
        y_loop:
            mov r8b, byte [y_value]
            inc r8b
            mov byte [z_value], r8b
            z_loop:
                call write
                call check_z
                call write_again
                inc byte [z_value]
                cmp byte [z_value], 58
                jne z_loop
            inc byte [y_value]
            cmp byte [y_value], 57
            jne y_loop
        inc byte [x_value]
        cmp byte [x_value], 56
        jne x_loop
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
                
