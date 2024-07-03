section .data

section .text
    global AsmDestroyCircle
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmDestroyCircle:
    cmp rdi, 0
    je .bye_error0

    push r12

    mov r12, rdi

    sub rsp, 8
    mov byte[rsp], 60
    mov word[rsp + 2], 2
    mov r8d, dword[CIRCLE_GC]
    mov dword[rsp + 4], r8d

    mov rax, 1
    mov rdi, qword[CIRCLE_LINK]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 8
    syscall
    add rsp, 8
    cmp rax, rdx
    jne .bye_error

    mov rdi, r12
    call AsmDalloc

    pop r12
    xor rax, rax
    ret

    .bye_error:
        pop r12
    .bye_error0:
        mov rax, -1
        ret