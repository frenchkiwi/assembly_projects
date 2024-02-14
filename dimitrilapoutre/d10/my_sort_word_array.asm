%include "my_macro.asm"

section .data
    string db " gay de merde a gaz", 0
section .text
    extern my_swap
    extern my_putchar
    extern my_putstr
    extern my_strcmp
    extern my_str_to_word_array
    extern my_show_word_array
    global _start

my_sort_word_array:
    mov rcx, -1
    cmp rdi, 0
    je .bye
    .loop:
        inc rcx
        cmp qword[8 + rdi + rcx * 8], 0
        je .bye
        mov rdx, rcx
        inc rdx
        .loop2:
            mov r8, [rdi + rcx * 8]
            mov r9, [rdi + rdx * 8]
            CALL_ my_strcmp, r8, r9
            cmp rax, 0
            jg .swap
            .back_up_loop2:
            inc rdx
            cmp qword[rdi + rdx * 8], 0
            jne .loop2
        jmp .loop
    .bye:
    mov rax, 0
    ret

    .swap:
        mov [rdi + rcx * 8], r9
        mov [rdi + rdx * 8], r8
        jmp .back_up_loop2

_start:
    CALL_ my_str_to_word_array, string
    mov rdi, rax
    CALL_ my_sort_word_array, rax
    CALL_ my_show_word_array, rdi
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
