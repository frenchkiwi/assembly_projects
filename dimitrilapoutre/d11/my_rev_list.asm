section .data

section .text
    global _start

my_rev_list:
    cmp rdi, 0
    je .bye
    mov rdx, rdi
    .loop:
        cmp qword [rdi + 8], 0
        je .continue
        mov rdi, [rdi + 8]
        jmp .loop
    .continue:
    mov rax, rdi
    .loop2:
        mov rsi, rdx
        .loop3:
            cmp qword [rsi + 8], rax
            je .add_next
            mov rsi, [rsi + 8]
            jmp .loop3
        .add_next:
        mov [rax + 8], rsi
        mov rax, [rax + 8]
        cmp rsi, rdx
        jne .loop2
    mov rsi, 0
    mov [rax + 8], rsi
    .bye:
    ret

_start:
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
