section .data

section .text
    global AsmDestroyText
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmDestroyText:
    cmp rdi, 0
    je .bye_error0

    push rbx
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi

    sub rsp, 8
    mov byte[rsp], 60
    mov word[rsp + 2], 2
    mov r8d, dword[TEXT_GC]
    mov dword[rsp + 4], r8d

    mov rax, 1
    mov rdi, qword[TEXT_LINK]
    mov rdi, qword[rdi]
    lea rsi, [rsp]
    mov rdx, 8
    syscall
    add rsp, 8
    cmp rax, rdx
    jne .bye_error
    
    mov rdi, qword[r12]
    call AsmDalloc

    mov rdi, r12
    call AsmDalloc

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    xor rax, rax
    ret

    .bye_error:
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
    .bye_error0:
        mov rax, -1
        ret