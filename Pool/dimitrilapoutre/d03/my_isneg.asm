section .data:
    nb db -97
    isneg_n db 'N'
    isneg_p db 'P'

section .text
    global _start

my_isneg:
    ; need isneg_n and isneg_p in section .data
    mov rax, 1
    mov rdi, 1
    mov rdx, 1

    cmp r8b, 0
    jl negative
    positive:
        mov rsi, isneg_p
        syscall
        ret
    negative:
        mov rsi, isneg_n
        syscall
        ret

_start:
    mov r8b, byte [nb]
    call my_isneg
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
