section .data

section .text
    global AsmSetColorRectangle
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmSetColorRectangle:
    cmp rdi, 0
    je .bye_error

    bswap esi
    cmp dword[rdi + 20], esi
    je .bye
    mov dword[rdi + 20], esi

    sub rsp, 16
    mov byte[rsp], 56
    mov word[rsp + 2], 4
    mov r8d, dword[rdi + 16]
    mov dword[rsp + 4], r8d
    mov dword[rsp + 8], 0x4
    mov dword[rsp + 12], esi

    mov rax, 1
    mov rdi, qword[rdi + 8]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 16
    syscall
    add rsp, 16
    cmp rax, rdx
    jne .bye_error

    .bye:
    xor rax, rax
    ret

    .bye_error:
        mov rax, -1
        ret