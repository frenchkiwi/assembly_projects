%include "my_macro.asm"

section .data

section .text
    global _start

my_apply_to_node:
    .loop:
        cmp rdi, 0
        je .bye
        CALL_ rsi, [rdi]
        mov rdi, [rdi + 8]
        jmp .loop
    .bye:
    mov rax, 0
    ret

_start:
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
