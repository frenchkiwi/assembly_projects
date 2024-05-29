; prints the alphabet

section .data
    letter db 'a'

section .text
    global _start

print_alpha:
    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    mov rsi, letter

    loop:
        syscall
        inc byte [letter]
        cmp byte [letter], 123
        jne loop

    mov byte [letter], 10
    syscall

    ret

exit:
    mov rax, 60
    mov rdi, 0
    syscall

_start:
    call print_alpha
    jmp exit
