section .data
    oue db "siuuu", 0

section .text
    extern my_strlen
    extern my_putstr
    global _start

my_strdup:
    mov r8, rdi
    mov rax, 12
    mov rdi, 0
    syscall
    mov r9, rax
    
    mov rdi, r8
    call my_strlen
    
    inc rax
    lea rdi, [r9 + rax]
    mov rax, 12
    syscall

    mov rcx, -1
    loop_strdup:
        inc rcx
        movzx r10, byte [r8 + rcx]
        mov byte [r9 + rcx], r10b
        cmp byte [r8 + rcx], 0
        jne loop_strdup
    mov rax, r9
    ret 

_start:
    mov rdi, oue
    call my_strdup
    mov rdi, rax
    call my_putstr
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

_error:
    mov rdi, rax
    mov rax, 60
    syscall
