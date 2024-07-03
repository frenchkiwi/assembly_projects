section .data

section .text
    global AsmCreateRectangle
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmCreateRectangle:
    cmp rdi, 0
    je .bye_error0

    push r12
    push r13
    push r14
    push r15
    mov r12, rdi
    mov r13, rsi
    mov r14, rdx
    bswap r14d

    sub rsp, 24
    mov byte[rsp], 55
    mov word[rsp + 2], 4 + 1
    mov r15d, dword[LINK_ID_GENERATOR]
    mov dword[rsp + 4], r15d
    inc dword[LINK_ID_GENERATOR]
    mov r8d, dword[LINK_ID]
    mov dword[rsp + 8], r8d
    mov dword[rsp + 12], 0x4
    mov dword[rsp + 16], r14d
    
    mov rax, 1
    mov rdi, qword[LINK_SOCKET]
    lea rsi, [rsp]
    mov rdx, 20
    syscall
    add rsp, 24
    cmp rax, rdx
    jne .bye_error

    mov rdi, 24
    call AsmAlloc
    cmp rax, 0
    je .bye_error

    mov qword[rax], r13
    mov qword[rax + 8], r12
    mov dword[rax + 16], r15d
    mov dword[rax + 20], r14d

    pop r15
    pop r14
    pop r13
    pop r12
    ret

    .bye_error:
        pop r15
        pop r14
        pop r13
        pop r12
    .bye_error0:
        xor rax, rax
        ret
