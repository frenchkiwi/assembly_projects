section .data
    gay dd 48, 0
section .text
    global _start

count_valid_queens_placements:
    ret

_start:
    call count_valid_queens_placements
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
