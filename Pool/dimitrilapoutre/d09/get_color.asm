%include "my_macro.inc"

section .data
    base db "0123456789", 0
section .text
    extern my_putnbr_base
    global _start

get_color:
    mov rax, 0
    movzx rdi, dil
    add rax, rdi
    shl rax, 8
    movzx rsi, sil
    add rax, rsi
    shl rax, 8
    movzx rdx, dl
    add rax, rdx
    ret

_start:
    CALL_ get_color, 210, 170, 255
    mov rdi, rax
    mov rsi, base
    call my_putnbr_base
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
