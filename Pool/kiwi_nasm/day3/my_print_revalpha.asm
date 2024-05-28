; prints the alphabet in reverse

section .data
    letter db 'z'

section .text
    global _start

print_revalpha:
    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    mov rsi, letter

    loop:
        syscall
        dec byte [letter]
        cmp byte [letter], 96
        jne loop

    mov byte [letter], 10
    syscall

    ret

exit:
    mov rax, 60
    mov rdi, 0
    syscall

_start:
    call print_revalpha
    jmp exit
