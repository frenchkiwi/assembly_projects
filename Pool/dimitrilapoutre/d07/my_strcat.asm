
section .data
    string1 db "va etre concat", 0, 0, 0, 0, 0
    string2 db " va etre concat aussi", 0
section .text
    extern my_putstr
    global _start

my_strcat:
    mov rcx, -1
    loop_destlen_strcat:
        inc rcx
        cmp byte [rdi + rcx], 0
        jne loop_destlen_strcat
    mov rdx, -1
    loop_strcat:
        inc rdx
        mov r8b, byte [rsi + rdx]
        add rcx, rdx
        mov byte [rdi + rcx], r8b
        sub rcx, rdx
        cmp byte [rsi + rdx], 0
        jne loop_strcat
    mov rax, rdi
    ret

_start:
    mov rdi, string1
    mov rsi, string2
    call my_strcat
    mov rdi, rax
    call my_putstr
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
