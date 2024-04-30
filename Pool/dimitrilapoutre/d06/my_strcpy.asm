section .data
    test1 dd "hello", 0
    test2 dd "war", 0
section .text
    extern my_putstr
    global _start

my_strcpy:
    mov rcx, -1
    loop_strcpy:
        inc rcx
        mov r8b, byte [rsi + rcx]
        mov byte [rdi + rcx], r8b
        cmp byte [rsi + rcx], 0
        jne loop_strcpy
    ret

_start:
    mov rdi, test1
    mov rsi, test2
    call my_strcpy
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
