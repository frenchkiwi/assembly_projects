section .data

section .text
    global _start

my_list_size:
    mov rcx, -1
    .loop:
        inc rcx
        cmp rdi, 0
        je .bye
        mov rdi, [rdi + 8]
        jmp .loop
    .bye:
    mov rax, rcx
    ret

_start:
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall