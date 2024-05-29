; prints the 10 digits in ascending order

section .data
    letter db '0'

section .text
    global _start

print_digits:
    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    mov rsi, letter

    loop:
        syscall
        inc byte [letter]
        cmp byte [letter], 58
        jne loop

    mov byte [letter], 10
    syscall

    ret

exit:
    mov rax, 60
    mov rdi, 0
    syscall

_start:
    call print_digits
    jmp exit
