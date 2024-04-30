%include "my_macro.asm"

section .data

section .text
    global _start

my_merge:
    CALL_ my_concat_list, rdi, rsi
    CALL_ my_sort_list, rdi, rdx
    ret

_start:
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
