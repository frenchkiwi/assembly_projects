section .data

section .text
    global AsmDestroyWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmDestroyWindow:
    sub rsp, 8

    mov r9, rdi
    cmp dword[r9 + 4], 0
    je .no_pixmap

    mov byte[rsp], 54
    mov word[rsp + 2], 2
    mov r10d, dword[r9 + 4]
    mov dword[rsp + 4], r10d

    mov rax, 1
    mov rdi, qword[rdi + 8]
    lea rsi, [rsp]
    mov rdx, 8
    syscall
    cmp rax, rdx
    jne .bye_error

    .no_pixmap:
    mov byte[rsp], 4
    mov word[rsp + 2], 2
    mov r8d, dword[r9]
    mov dword[rsp + 4], r8d

    mov rax, 1
    ; rdi already set
    lea rsi, [rsp]
    mov rdx, 8
    syscall
    cmp rax, rdx
    jne .bye_error

    mov rdi, r9
    call AsmDalloc

    add rsp, 8
    xor rax, rax
    ret

    .bye_error:
        add rsp, 8
        mov rax, -1
        ret