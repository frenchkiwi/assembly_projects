%include "my_macro.asm"

section .data
    base db "0123456789", 0
    ref db "de", 0
section .text
    extern my_putchar
    extern my_putstr
    extern my_strcmp
    extern my_putnbr_base
    extern my_apply_to_nodes
    extern my_delete_nodes
    extern my_concat_list
    extern my_sort_list
    extern get_ptr
    extern my_add_in_sorted_list
    extern my_merge
    global _start

my_params_to_list:
    mov rax, 0
    mov rcx, 1
    .loop:
        inc rcx
        mov rdi, 0
        mov rdi, [rsp + rcx * 8]
        cmp rdi, 0
        je .bye
        call .add_param_to_list
        jmp .loop
    .bye:
    ret
    .add_param_to_list:
        push rcx
        push rax
        push rdi
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
        pop rcx
        mov rax, r10
        ret
_start:
    call my_params_to_list
    CALL_ get_ptr, rax
    mov r12, rax
    call my_params_to_list
    CALL_ my_merge, r12, rax, my_strcmp
    CALL_ my_apply_to_nodes, [r12], my_putstr
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
