%include "my_macro.asm"

section .data

section .text
    global _start

my_concat_list:
    mov r8, rdi
    cmp r8, 0
    je .no_first
    xor r9, r9
    .loop:
        cmp [r8 + 8], r9
        je .link
        mov r8, [r8 + 8]
        jmp .loop
    .link:
        mov [r8 + 8], rsi
    .bye:
    mov rax, 0
    ret
    .no_first:
        mov rdi, rsi
        jmp .bye

_start:
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
