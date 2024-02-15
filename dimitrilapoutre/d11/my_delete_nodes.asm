%include "my_macro.asm"

section .data

section .text
    global _start

my_delete_nodes:
    mov r8, rdi
    .loop:
        cmp r8, 0
        je .bye
        cmp r8, rdi
        je .first_node
        CALL_ rdx, [r8], rsi
        cmp rax, 0
        je .continue
        mov [r9 + 8], r8
        mov r9, [r9 + 8]
        .continue:
        mov r8, [r8 + 8]
        jmp .loop
    .bye:
    cmp rdi, 0
    je .bye2
    mov [r9 + 8], r8
    .bye2:
    mov rax, 0
    ret

    .first_node:
        CALL_ rdx, [r8], rsi
        cmp rax, 0
        je .move_begin
        mov r9, r8
        jmp .continue
        .move_begin:
            mov rdi, [r8 + 8]
            jmp .continue

_start:
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
