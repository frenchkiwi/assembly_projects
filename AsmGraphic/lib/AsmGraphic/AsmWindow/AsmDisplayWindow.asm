section .data

section .text
    global AsmDisplayWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmDisplayWindow:
    cmp rdi, 0
    je .bye_error
    cmp dword[rdi + 4], 0
    je .bye

    sub rsp, 32
    mov byte[rsp], 62 ; code copy area
    mov word[rsp + 2], 7 ; length
    mov r8d, dword[rdi + 4]
    mov dword[rsp + 4], r8d ; pixmap_id
    mov r8d, dword[rdi]
    mov dword[rsp + 8], r8d ; window_id
    mov r8d, dword[rdi + 26]
    mov dword[rsp + 12], r8d ; gc
    mov dword[rsp + 16], 0 ; x and y dest
    mov dword[rsp + 20], 0 ; x and y src
    mov r8d, dword[rdi + 20]
    mov dword[rsp + 24], r8d ; width and heigth

    mov rax, 1
    mov rdi, qword[rdi + 8]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 28
    syscall
    add rsp, 32
    cmp rax, rdx
    jne .bye_error
    
    .bye:
    xor rax, rax
    ret

    .bye_error:
        mov rax, -1
        ret