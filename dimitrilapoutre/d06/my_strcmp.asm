section .data
    test1 db "gay", 0
    test2 db "gay", 0
section .text
    extern my_put_nbr
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
        mov al, byte [rsi + rcx]
        sub al, byte [rdi + rcx]
        ret

_start:
    mov rdi, test1
    mov rsi, test2
    call my_strcmp
    jmp _exit

_exit:
    mov rdi, rax
    mov rax, 60
    syscall
