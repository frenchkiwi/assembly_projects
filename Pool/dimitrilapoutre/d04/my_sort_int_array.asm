section .data
    array dd 5, 2, 6, 2, 7, 5

section .text
    global _start

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

_start:
    lea rdi, array
    mov rsi, 6
    call my_sort_int_array
    jmp _exit

_exit:
    mov rax, 60
    mov edi, 0
    syscall
