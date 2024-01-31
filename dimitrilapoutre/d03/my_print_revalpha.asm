section .data
    letter db 122

section .text
    global _start

write:
    mov rax, 1
    mov rdi, 1
    mov rsi, letter
    mov rdx, 1
    syscall
    ret

_start:
    loop:
        call write
        dec byte [letter]
        cmp byte [letter], 96
        jne loop


_exit:
    mov rax, 60
    mov rdi, 0
    syscall
