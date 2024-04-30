section .data
    test1 db " apple", 0
    test2 db ".banana", 0
    base db "0123456789", 0
section .text
    extern my_putnbr_base
    global _start

my_strcmp:
    mov rcx, -1
    loop_strcmp:
        inc rcx
        mov r9b, byte [rsi + rcx]
        cmp byte [rdi + rcx], r9b
        jne bye_strcmp
        cmp byte [rdi + rcx], 0
        jne loop_strcmp
    mov rax, 0
    ret

    bye_strcmp:
        movzx rax, byte [rdi + rcx]
        movzx rbx, byte [rsi + rcx]
        sub rax, rbx
        ret

_start:
    mov rdi, test1
    mov rsi, test2
    call my_strcmp
    mov rdi, rax
    mov rsi, base
    call my_putnbr_base
    jmp _exit

_exit:
    mov rdi, rax
    mov rax, 60
    syscall
