section .data
    number dq 69
    value dd 0

section .text
    global _start

recursif:
    mov dword [number], eax
    push qword [number]
    call my_put_nbr
    jmp print_modulo

my_put_nbr:
    pop rax
    pop qword [number]
    push qword [number]
    push rax

    mov eax, dword [number]
    xor edx, edx
    mov ebx, 10
    div ebx

    cmp eax, 0
    jne recursif

    print_modulo:
        pop rax
        pop qword [number]
        push rax

        mov eax, dword [number]
        xor edx, edx
        mov ebx, 10
        div ebx

        mov dword [value], edx
        add dword [value], 48

        mov rax, 1
        mov rdi, 1
        mov rsi, value
        mov rdx, 1
        syscall

    ret

my_put_negnbr:
    mov dword [value], 45
    mov rax, 1
    mov rdi, 1
    mov rsi, value
    mov rdx, 1
    syscall

    neg qword [number]
    push qword [number]
    call my_put_nbr
    jmp _exit

_start:
    cmp qword [number], -2147483648
    jl _error
    cmp qword [number], 2147483647
    jg _error

    cmp qword [number], 0
    jl my_put_negnbr
    push qword [number]
    call my_put_nbr
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

_error:
    mov rax, 60
    mov rdi, 84
    syscall
