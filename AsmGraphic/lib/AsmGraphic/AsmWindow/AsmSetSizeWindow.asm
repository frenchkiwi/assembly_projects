section .data

section .text
    global AsmSetSizeWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmSetSizeWindow:
   cmp rdi, 0
    je .bye_error

    sub rsp, 24
    mov byte[rsp], 12
    mov word[rsp + 2], 5
    mov r8d, dword[rdi]
    mov dword[rsp + 4], r8d
    mov word[rsp + 8], 0x4 | 0x8 ; width | heigth
    movzx r8, si
    mov dword[rsp + 12], r8d
    shr rsi, 16
    movzx r8, si
    mov dword[rsp + 16], r8d

    mov r8, rdi
    mov rax, 1
    mov rdi, qword[rdi + 8]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 20
    syscall
    add rsp, 24
    cmp rax, rdx
    jne .bye_error

    push r12
    mov r12, r8

    mov rdi, r12
    mov rsi, 22
    call AsmWaitEvent
    mov r8d, dword[rax + 8 + 20]
    mov dword[WINDOW_SIZE], r8d
    mov rdi, rax
    call AsmDalloc

    mov rdi, r12
    mov rsi, 22
    call AsmWaitEvent
    mov rdi, rax
    call AsmDalloc

    pop r12

    xor rax, rax
    ret

    .bye_error:
        mov rax, -1
        ret