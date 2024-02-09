%include "my_macro.inc"

section .data
    base db "0123456789", 0
section .text
    extern my_putnbr_base
    global _start

swap_endian_color:
    xor rax, rax
    add al, dil
    shr rdi, 8
    shl rax, 8
    add al, dil
    shr rdi, 8
    shl rax, 8
    add al, dil
    shr rdi, 8
    shl rax, 8
    add al, dil
    ret

_start:
    mov edi, 4289379276
    call swap_endian_color
    mov rdi, rax
    mov rsi, base
    call my_putnbr_base
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall

_info:
    movzx rdi, al
    mov rax, 60
    syscall
