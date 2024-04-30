section .data

section .text
    global memcpy

memcpy:
    mov rcx, -1
    .loop:
        inc rcx
        cmp rdx, rcx
        je .bye
        mov r8b, byte [rsi]
        mov byte [rdi + rcx], r8b
        jmp .loop
    .bye:
    mov rax, rdi
    ret
