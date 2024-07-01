section .data

section .text
    global AsmDestroyFont
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmDestroyFont:
    cmp rdi, 0
    je .bye_error

    mov r8, rdi

    sub rsp, 8
    mov byte[rsp], 46
    mov word[rsp + 2], 2
    mov r9d, dword[r8]
    mov dword[rsp + 4], r9d

    mov rax, 1
    mov rdi, qword[r8 + 4]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 8
    syscall
    add rsp, 8
    cmp rax, rdx
    jne .bye_error

    mov rdi, r8
    call AsmDalloc

    xor rax, rax
    ret

    .bye_error:
        mov rax, -1
        ret