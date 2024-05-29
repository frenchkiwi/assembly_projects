; prints the alphabet

section .data
    letter db 0
    format db "%s", 0

section .text
    global _start

arg_null:
    mov rdi, [rsp + 16]
    cmp rdi, 0
    je error
    jmp is_neg

is_neg:
    mov rax, 0
    mov rsi, format
    mov rdx, 1
    syscall

    ret

error:
    mov rax, 60
    mov rdi, 84
    syscall

exit:
    mov rax, 60
    mov rdi, 0
    syscall

_start:
    call arg_null
    jmp exit
