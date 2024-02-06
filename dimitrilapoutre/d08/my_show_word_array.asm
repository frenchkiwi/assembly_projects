section .data
    string1 db "gay", 0
    string2 db "homo", 0
    string3 db "pd", 0

    list_char dq string1, string2, string3, 0

section .text
    extern my_putstr
    global _start

my_show_word_array:
    mov rsi, rdi
    mov rcx, -1
    loop_show_word_array:
        inc rcx
        mov rdi, [rsi + rcx * 8]
        cmp rdi, 0
        je bye_show_word_array
        push rsi
        push rcx
        call my_putstr
        pop rcx
        pop rsi
        push rsi
        push rcx
        mov r8b, byte [rsi + rcx * 8]
        mov rax, 1
        mov rdi, 1
        mov byte [rsi + rcx * 8], 10
        lea rsi, byte [rsi + rcx * 8]
        mov rdx, 1
        syscall
        pop rcx
        pop rsi
        mov byte [rsi + rcx * 8], r8b
        jmp loop_show_word_array
    bye_show_word_array:
    mov rax, 0
    ret

_start:
    mov rdi, list_char
    call my_show_word_array
    jmp _exit

_exit:
    mov rdi, 0
    mov rax, 60
    syscall
