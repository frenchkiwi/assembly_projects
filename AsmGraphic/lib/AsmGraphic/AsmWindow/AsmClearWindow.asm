section .data

section .text
    global AsmClearWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmClearWindow:
    cmp rdi, 0
    je .bye_error0
    bswap esi

    push r12
    mov r12, rdi

    cmp dword[rdi + 30], esi
    je .clear_window

    sub rsp, 16
    mov byte[rsp], 56
    mov word[rsp + 2], 4
    mov r8d, dword[WINDOW_GC]
    mov dword[rsp + 4], r8d
    mov dword[rsp + 8], 0x4
    mov dword[rsp + 12], esi
    
    mov rax, 1
    mov rdi, qword[WINDOW_LINK]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 16
    syscall
    add rsp, 16
    cmp rax, rdx
    jne .bye_error

    .clear_window:
    sub rsp, 24
    mov byte[rsp], 70
    mov word[rsp + 2], 5
    mov r8d, dword[WINDOW_PIXMAP]
    mov dword[rsp + 4], r8d
    mov r8d, dword[WINDOW_GC]
    mov dword[rsp + 8], r8d
    mov dword[rsp + 12], 0
    mov r8d, dword[WINDOW_SIZE]
    mov dword[rsp + 16], r8d

    mov rax, 1
    mov rdi, qword[WINDOW_LINK]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 20
    syscall
    add rsp, 24
    cmp rax, rdx
    jne .bye_error

    pop r12

    .bye:
    xor rax, rax
    ret

    .bye_error:
        pop r12
    .bye_error0:
        mov rax, -1
        ret