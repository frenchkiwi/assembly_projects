section .data
    test1 dd "hello", 0
    test2 dd "war", 0
section .text
    extern my_putstr
    global _start

my_strncpy:
    mov rcx, -1
    loop_strncpy:
        inc rcx
        cmp rdx, rcx
        je bye_strncpy
        mov r8b, byte [rsi + rcx]
        mov byte [rdi + rcx], r8b
        cmp byte [rsi + rcx], 0
        jne loop_strncpy
    bye_strncpy:
        mov rax, rdi
        ret

_start:
    mov rdi, test1
    mov rsi, test2
    mov rdx, 3
    call my_strncpy
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
