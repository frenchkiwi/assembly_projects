section .data

section .text
    global AsmDrawRectangle
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmDrawRectangle:
    cmp rdi, 0
    je .bye_error0
    cmp dword[rdi + 4], 0
    je .bye
    cmp rsi, 0
    je .bye_error0

    sub rsp, 24
    mov byte[rsp], 70
    mov word[rsp + 2], 5
    mov r8d, dword[rdi + 4]
    mov dword[rsp + 4], r8d
    mov r8d, dword[rsi + 16]
    mov dword[rsp + 8], r8d
    mov r8, qword[rsi]
    mov qword[rsp + 12], r8

    mov rax, 1
    mov rdi, qword[rdi + 8]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 20
    syscall
    add rsp, 24
    cmp rax, rdx
    jne .bye_error0

    .bye:
    xor rax, rax
    ret

    .bye_error0:
        mov rax, -1
        ret