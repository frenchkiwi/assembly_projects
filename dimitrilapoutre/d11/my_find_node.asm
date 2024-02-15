%include "my_macro.asm"

section .data

section .text
    global _start

my_find_node:
    mov r8, rdi
    .loop:
        cmp r8, 0
        je .bye
        CALL_ rdx, [r8], rsi
        cmp rax, 0
        jne .continue
        mov rax, r8
        ret
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
