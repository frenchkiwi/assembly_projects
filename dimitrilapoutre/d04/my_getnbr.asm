section .data
    string dq "2147483647", 0

section .text
    global _start

my_getnbr:
    mov r8, 1
    mov r9, 0
    mov rax, 0
    mov rcx, -1
    loop_getnbr:
        cmp rax, 2147483647
        jg zero
        cmp rax, -2147483648
        jl zero
        inc rcx
        cmp byte [rdi + rcx], 45
        je neg
        cmp byte [rdi + rcx], 43
        je pos
        cmp byte [rdi + rcx], 48
        jl bye
        cmp byte [rdi + rcx], 57
        jg bye
        
        mov r9, 1

        mov rdx, 10
        mul rdx

        movzx rbx, byte [rdi + rcx]
        sub bl, 48
        add rax, rbx
        jmp loop_getnbr

    zero:
        mov rax, 0
        ret

    pos:
        cmp r9, 0
        jne bye
        jmp loop_getnbr

    neg:
        cmp r9, 0
        jne bye
        neg r8
        jmp loop_getnbr

    bye:
        cmp r8, 1
        je bye2
        neg rax
        bye2:
            ret

_start:
    mov rdi, string
    call my_getnbr
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
