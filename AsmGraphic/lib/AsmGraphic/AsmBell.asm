section .data

section .text
    global AsmBell
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmBell:
    cmp rdi, 0
    je .bye_error
    cmp rsi, -100
    jb .bye_error
    cmp rsi, 100
    ja .bye_error

    sub rsp, 8
    mov byte[rsp], 104
    mov byte[rsp + 1], sil
    mov word[rsp + 2], 1

    mov rax, 1
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 4
    syscall
    add rsp, 8
    cmp rax, rdx
    jne .bye_error

    xor rax, rax
    ret

    .bye_error:
        mov rax, -1
        ret