section .data

section .text
    global putchar
    global puts

putchar:
    mov dl, dil
    mov rax, 12
    mov rdi, 0
    syscall
    mov rsi, rax
    mov rax, 12
    lea rdi, [rsi + 1]
    syscall
    
    mov byte [rsi], dl
    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    syscall

    mov rax, 12
    lea rdi, [rsi]
    syscall

    mov rax, rdx
    ret

puts:
    cmp rdi, 0
    je .bye_putstr
    mov rsi, rdi
    mov rdx, -1
    .loop_putstr:
        inc rdx
        cmp byte [rsi + rdx], 0
        jne .loop_putstr
    mov rax, 1
    mov rdi, 1
    syscall
    mov rdi, 10
    call putchar
    .bye_putstr:
        mov rax, 0
        ret
