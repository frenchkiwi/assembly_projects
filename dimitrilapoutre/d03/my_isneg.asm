section .data:
    nb_tested db 97
    positive db 80
    negative db 78

section .text
    global _start

_start:
    mov r8, negative
    cmp byte [nb_tested], 0
    jl write
    mov r8, positive
    jmp write

write:
    mov rax, 1
    mov rdi, 1
    mov rsi, r8
    mov rdx, 1
    syscall

    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
