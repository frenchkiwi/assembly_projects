section .data
    test1 db "oui", 0
    test2 db "oui", 0
section .text
    extern my_put_nbr
    global _start

my_strncmp:
    mov rcx, -1
    dec rdx
    cmp rdx, 0
    jl bye_strncmp
    loop_strncmp:
        inc rcx
        cmp rcx, rdx
        je bye_strncmp2
        mov r9b, byte [rsi + rcx]
        cmp byte [rdi + rcx], r9b
        jne bye_strncmp2
        cmp byte [rdi + rcx], 0
        jne loop_strncmp
    
    bye_strncmp:
    mov rax, 0
    ret

    bye_strncmp2:
        mov al, byte [rsi + rcx]
        sub al, byte [rdi + rcx]
        ret

_start:
    mov rdi, test1
    mov rsi, test2
    mov rdx, 3
    call my_strncmp
    jmp _exit

_exit:
    mov rdi, rax
    mov rax, 60
    syscall
