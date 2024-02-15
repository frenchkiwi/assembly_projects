%include "my_macro.asm"

section .data

section .text
    global _start

my_apply_to_matching_nodes:
    mov rax, rdi
    .loop:
        cmp rax, 0
        je .bye
        CALL_ rcx, [rax], rdx
        cmp rax, 0
        jne .continue
        CALL_ rsi, [rax]
        .continue:
        mov rax, [rax + 8]
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
