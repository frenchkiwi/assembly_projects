section .data

section .text
    global AsmDestroyWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmDestroyWindow:
    cmp rdi, 0
    je .bye_error0
    sub rsp, 8

    mov r8, rdi
    cmp dword[r8 + 4], 0
    je .no_pixmap

    mov byte[rsp], 54
    mov word[rsp + 2], 2
    mov r9d, dword[r8 + 4]
    mov dword[rsp + 4], r9d

    mov rax, 1
    mov rdi, qword[r8 + 8]
    lea rsi, [rsp]
    mov rdx, 8
    syscall
    cmp rax, rdx
    jne .bye_error

    .no_pixmap:
    mov byte[rsp], 4
    mov word[rsp + 2], 2
    mov r9d, dword[r8]
    mov dword[rsp + 4], r9d

    mov rax, 1
    mov rdi, qword[r8 + 8]
    lea rsi, [rsp]
    mov rdx, 8
    syscall
    cmp rax, rdx
    jne .bye_error

    mov rdi, r8
    call AsmDalloc

    add rsp, 8
    xor rax, rax
    ret

    .bye_error:
        add rsp, 8
    .bye_error0:
        mov rax, -1
        ret