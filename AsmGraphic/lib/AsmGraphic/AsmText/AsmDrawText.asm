section .data

section .text
    global AsmDrawText
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmDrawText:
    cmp rdi, 0
    je .bye_error0
    cmp dword[rdi + 4], 0
    je .bye
    cmp rsi, 0
    je .bye_error0

    push r12
    push r13
    push r14
    push r15

    mov r12, rsi
    mov r13, rdi

    mov rdi, qword[TEXT_STRING]
    call AsmStrlen
    mov r14, rax

    neg rax
    and rax, -4
    neg rax
    add rax, 16
    mov r15, rax

    neg rax
    and rax, -8
    neg rax
    sub rsp, rax
    mov byte[rsp], 76
    mov byte[rsp + 1], r14b
    mov rax, r15
    xor rdx, rdx
    mov r8, 4
    div r8
    mov word[rsp + 2], ax
    mov r8d, dword[r13 + 4]
    mov dword[rsp + 4], r8d
    mov r8d, dword[TEXT_GC]
    mov dword[rsp + 8], r8d
    mov r8d, dword[TEXT_POS]
    mov dword[rsp + 12], r8d
    xor rcx, rcx
    mov r13, qword[TEXT_STRING]
    .copy_string:
        cmp rcx, r14
        je .bye_copy_string
        mov r8b, byte[r13 + rcx]
        mov byte[rsp + 16 + rcx], r8b
        inc rcx
        jmp .copy_string

    .bye_copy_string:
    mov rax, 1
    mov rdi, qword[TEXT_LINK]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, r15
    syscall
    neg r15
    and r15, -8
    neg r15
    add rsp, r15
    cmp rax, rdx
    jne .bye_error

    pop r15
    pop r14
    pop r13
    pop r12
    .bye:
    xor rax, rax
    ret

    .bye_error:
        pop r15
        pop r14
        pop r13
        pop r12
    .bye_error0:
        mov rax, -1
        ret