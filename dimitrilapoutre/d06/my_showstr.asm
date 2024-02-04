section .data
    string db "I like ", 10, " ponies!", 0

section .text
    extern my_putnbr_base
    global _start

my_showstr:
    mov r8, rdi
    mov r9, -1
    loop_showstr:
        inc r9
        cmp byte [r8 + r9], 0
        je bye_showstr
        jmp check_showstr

    bye_showstr:
        mov rax, 0
        ret

    check_showstr:
        cmp byte [r8 + r9], ' '
        jl np_showstr
        cmp byte [r8 + r9], '~'
        jg np_showstr
        jmp p_showstr

    p_showstr:
        mov rax, 1
        mov rdi, 1
        lea rsi, [r8 + r9]
        mov rdx, 1
        syscall
        jmp loop_showstr

    np_showstr:
        mov rax, 1
        mov rdi, 1
        mov rdx, 1

        push r8
        mov byte [r8], '\' 
        lea rsi, [r8]
        syscall
        pop r8
        
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

        push r8
        call is_hexa_showstr
        mov byte [r8], r10b
        lea rsi, [r8]
        mov r10, r11
        syscall
        call is_hexa_showstr
        mov byte [r8], r10b
        call is_hexa_showstr
        lea rsi, [r8]
        syscall
        pop r8

        jmp loop_showstr

        is_hexa_showstr:
            cmp r10, 58
            jl bye_is_hexa_showstr
            add r10, 39
            bye_is_hexa_showstr:
                ret

_start:
    mov rdi, string
    call my_showstr
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
