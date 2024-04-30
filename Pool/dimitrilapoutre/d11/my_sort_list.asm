%include "my_macro.asm"

section .data

section .text
    global _start

my_sort_list:
    mov rcx, [rdi]
    cmp rcx, 0
    je .bye
    xor r10, r10
    mov r11, rsi
    .loop:
        cmp [rcx + 8], r10
        je .bye
        mov rdx, [rcx + 8]
        .loop2:
            cmp rdx, 0
            je .continue
            CALL_ r11, [rcx], [rdx]
            cmp rax, 0
            jg .swap
            .continue2:
            mov rdx, [rdx + 8]
            jmp .loop2
        .continue:
        mov rcx, [rcx + 8]
        jmp .loop
    .bye:
    xor rax, rax
    ret

    .swap:
        mov r8, [rcx]
        mov r9, [rdx]
        mov [rcx], r9
        mov [rdx], r8
        jmp .continue2

_start:
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
