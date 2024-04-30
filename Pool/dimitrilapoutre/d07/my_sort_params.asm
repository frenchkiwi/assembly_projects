section .data
    base db "0123456789", 0
section .text
    extern my_putstr
    extern my_putnbr_base
    extern my_strcmp
    global _start

_start:
    mov rcx, 1
    loop_sort_sort_params:
        mov rdi, 0
        mov rdi, [rsp + rcx * 8]
        cmp rdi, 0
        je bye_sort_sort_params
        mov rdx, rcx
        loop_sort_sort_params2:
            inc rdx
            mov rsi, 0
            mov rsi, [rsp + rdx * 8]
            cmp rsi, 0
            je bye_sort_sort_params2
            push rcx
            push rdx
            call my_strcmp
            pop rdx
            pop rcx
            cmp rax, 0
            jg swap_sort_sort_params
            back_up_sort_sort_params:
                jmp loop_sort_sort_params2
        bye_sort_sort_params2:
            inc rcx
            jmp loop_sort_sort_params
    
    swap_sort_sort_params:
        mov r8, [rsp + rcx * 8]
        mov r9, [rsp + rdx * 8]
        mov [rsp + rcx * 8], r9
        mov [rsp + rdx * 8], r8
        jmp back_up_sort_sort_params
    bye_sort_sort_params:
        mov rdx, 1
    loop_sort_params:
        mov rdi, 0
        mov rdi, [rsp + 8 * rdx]
        cmp rdi, 0
        je bye_sort_params
        push rdx
        push rdi
        call my_putstr
        pop r8
        mov r9b, byte [r8]
        mov byte [r8], 10
        mov rax, 1
        lea rsi, [r8]
        mov rdi, 1
        mov rdx, 1
        syscall
        mov byte [r8], r9b
        pop rdx
        inc rdx
        jmp loop_sort_params
    bye_sort_params:
        jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

_error:
    mov rdi, rax
    mov rsi, base
    call my_putnbr_base
    mov rdi, rax
    mov rax, 60
    syscall
