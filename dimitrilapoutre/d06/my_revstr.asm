section .data
    string db "hello world", 0

section .text
    global _start

my_revstr:
    mov rcx, -1
    loop_revstr:
        inc rcx
        cmp byte [rdi + rcx], 0
        jne loop_revstr
    
    mov rax, rcx
    xor rdx, rdx
    mov rbx, 2
    div rbx
    xchg rax, rcx

    mov rbx, 0
    loop_revstr2:
        dec rax
        mov r8b, byte [rdi + rbx]
        mov r9b, byte [rdi + rax]
        mov byte [rdi + rbx], r9b
        mov byte [rdi + rax], r8b
        inc rbx
        loop loop_revstr2
    mov rax, rdi
    ret

write:
    mov rsi, rax
    mov rax, 1
    mov rdi, 1
    mov rdx, 11
    syscall
    ret

_start:
    lea rdi, string
    call my_revstr
    call write
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
