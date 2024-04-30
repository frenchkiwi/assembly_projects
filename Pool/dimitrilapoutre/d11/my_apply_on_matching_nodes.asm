%include "my_macro.asm"

section .data

section .text
    global _start

my_apply_to_matching_nodes:
    mov r8, rdi
    .loop:
        cmp r8, 0
        je .bye
        CALL_ rcx, [r8], rdx
        cmp rax, 0
        jne .continue
        CALL_ rsi, [r8]
        .continue:
        mov r8, [r8 + 8]
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
