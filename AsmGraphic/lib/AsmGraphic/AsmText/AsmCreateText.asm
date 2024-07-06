section .data

section .text
    global AsmCreateText
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmCreateText:
    cmp rdi, 0
    je .bye_error0
    cmp rsi, 0
    je .bye_error0
    cmp rdx, 0
    je .bye_error0

    push rbx
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi
    mov r13, rsi
    mov r14, rdx
    mov r15, rcx

    mov rdi, r13
    call AsmStrlen
    cmp rax, 255
    jg .bye_error

    mov rdi, 32
    call AsmAlloc
    cmp rax, 0
    je .bye_error
    mov rbx, rax

    mov rdi, r13
    call AsmStrdup
    cmp rax, 0
    je .bye_error

    mov qword[rbx], rax
    mov qword[rbx + 8], r12
    mov dword[rbx + 20], r15d
    mov dword[rbx + 24], 0x00FFFFFF

    sub rsp, 16 + 4 + 4; gc create request + 2 value
    mov byte[rsp], 55
    mov word[rsp + 2], 4 + 2
    mov r8d, dword[LINK_ID_GENERATOR]
    mov dword[rsp + 4], r8d
    mov dword[rbx + 16], r8d
    inc dword[LINK_ID_GENERATOR]
    mov r8d, dword[LINK_ID]
    mov dword[rsp + 8], r8d
    mov dword[rsp + 12], 0x00000004 | 0x00004000 ; foreground | font
    mov dword[rsp + 16], 0x00FFFFFF
    mov r8d, dword[r14]
    mov dword[rsp + 20], r8d

    mov rax, 1
    mov rdi, qword[LINK_SOCKET]
    lea rsi, [rsp]
    mov rdx, 16 + 4 + 4
    syscall
    add rsp, 16 + 4 + 4
    cmp rax, rdx
    jne .bye_errorD2

    mov rax, rbx

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

    .bye_errorD2:
        mov rdi, qword[rbx]
        call AsmDalloc
    .bye_errorD:
        mov rdi, rbx
        call AsmDalloc
    .bye_error:
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
    .bye_error0:
        xor rax, rax
        ret