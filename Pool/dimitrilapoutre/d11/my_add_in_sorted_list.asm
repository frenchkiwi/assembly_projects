%include "my_macro.asm"

section .data

section .text
    global _start

my_add_in_sorted_list:
    push rdi
    mov rax, [rdi]
    push rax
    push rsi
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
    pop rdi
    mov [rdi], r10
    CALL_ my_sort_list, rdi, rdx
    ret


_start:
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
