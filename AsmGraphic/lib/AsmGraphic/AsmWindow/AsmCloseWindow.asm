section .data

section .text
    global AsmCloseWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmCloseWindow:
    cmp rdi, 0
    je .bye_error
    cmp dword[rdi + 4], 0
    je .bye_error

    mov r8, rdi

    sub rsp, 8
    mov byte[rsp], 10
    mov word[rsp + 2], 2
    mov r9d, dword[r8]
    mov dword[rsp + 4], r9d

    mov rax, 1
    mov rdi, qword[r8 + 8]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 8
    syscall
    add rsp, 8
    cmp rax, rdx
    jne .bye_error

    sub rsp, 8
    mov byte[rsp], 54
    mov word[rsp + 2], 2
    mov r9d, dword[r8 + 4]
    mov dword[rsp + 4], r9d

    mov rax, 1
    mov rdi, qword[r8 + 8]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 8
    syscall
    add rsp, 8
    cmp rax, rdx
    jne .bye_error

    mov dword[r8 + 4], 0

    push r12
    mov r12, r8

    mov rdi, r12
    mov rsi, 18
    call AsmWaitEvent
    mov rdi, rax
    call AsmDalloc

    mov rdi, r12
    mov rsi, 21
    call AsmWaitEvent
    mov rdi, rax
    call AsmDalloc

    pop r12

    xor rax, rax
    ret

    .bye_error:
        mov rax, -1
        ret