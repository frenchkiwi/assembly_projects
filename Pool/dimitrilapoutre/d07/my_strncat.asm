
section .data
    string1 db "va etre concat", 0, 0, 0, 0, 0
    string2 db " va etre concat aussi", 0
section .text
    extern my_putstr
    global _start

my_strncat:
    mov r9, rdx
    mov rcx, -1
    loop_destlen_strncat:
        inc rcx
        cmp byte [rdi + rcx], 0
        jne loop_destlen_strncat
    mov rdx, -1
    loop_strncat:
        inc rdx
        cmp rdx, r9
        je bye_strncat
        cmp byte [rsi + rdx], 0
        je bye_strncat
        mov r8b, byte [rsi + rdx]
        add rcx, rdx
        mov byte [rdi + rcx], r8b
        sub rcx, rdx
        jmp loop_strncat
    bye_strncat:
        add rcx, rdx
        mov byte [rdi + rcx], 0
        mov rax, rdi
        ret

_start:
    mov rdi, string1
    mov rsi, string2
    mov rdx, 2
    call my_strncat
    mov rdi, rax
    call my_putstr
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
