%include "my_macro.asm"

section .data
    base db "0123456789", 0
    ref db "gay", 0
section .text
    extern my_putchar
    extern my_putstr
    extern my_strcmp
    extern my_putnbr_base
    extern my_apply_to_nodes
    extern my_delete_nodes
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
    mov rdi, rax
    CALL_ my_delete_nodes, rdi, ref, my_strcmp
    CALL_ my_apply_to_nodes, rdi, my_putstr
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
