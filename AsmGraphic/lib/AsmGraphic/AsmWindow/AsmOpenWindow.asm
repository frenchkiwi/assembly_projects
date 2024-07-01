section .data

section .text
    global AsmOpenWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmOpenWindow:
    cmp rdi, 0
    je .bye_error0
    cmp dword[rdi + 4], 0
    jne .bye

    sub rsp, 16
    mov byte[rsp], 53 ; create pixmap
    mov r8b, byte[rdi + 24]
    mov byte[rsp + 1], r8b ; set depth
    mov word[rsp + 2], 4 ; set length
    mov r8, qword[rdi + 8]
    mov r9d, dword[r8 + 8]
    mov dword[rsp + 4], r9d ; set pixmap id
    inc dword[r8 + 8]; next id
    mov r8d, dword[rdi]
    mov dword[rsp + 8], r8d ; set ref window id
    mov r8d, dword[rdi + 20]
    mov dword[rsp + 12], r8d ; set width and heigth

    mov r8d, dword[rsp + 4]
    mov dword[rdi + 4], r8d
    mov r8, rdi ; save window

    mov rax, 1
    mov rdi, qword[r8 + 8]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 16
    syscall
    add rsp, 16
    cmp rax, rdx
    jne .bye_error

    sub rsp, 8
    mov byte[rsp], 8
    mov byte[rsp + 1], 0
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

    push r12
    mov r12, qword[r8 + 8]

    mov rdi, r12
    mov rsi, 19
    call AsmWaitEvent
    mov rdi, rax
    call AsmDalloc

    mov rdi, r12
    mov rsi, 21
    call AsmWaitEvent
    mov rdi, rax
    call AsmDalloc

    mov rdi, r12
    mov rsi, 22
    call AsmWaitEvent
    mov rdi, rax
    call AsmDalloc

    pop r12

    .bye:
    xor rax, rax
    ret

    .bye_error:
        mov dword[r8], 0
    .bye_error0:
        mov rax, -1
        ret