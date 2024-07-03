section .data

section .text
    global AsmCreateFont
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmCreateFont:
    cmp rdi, 0
    je .bye_error0
    cmp rsi, 0
    je .bye_error0

    push rbx
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi
    mov r13, rsi

    mov rdi, r13
    call AsmStrlen
    mov r14, rax
    neg rax
    and rax, -4
    neg rax
    add rax, 12
    mov r15, rax

    neg rax
    and rax, -8
    neg rax
    sub rsp, rax
    mov byte[rsp], 45 ; openfont request
    mov rax, r15
    xor rdx, rdx
    mov r8, 4
    div r8
    mov word[rsp + 2], ax ; length of request 3 + (strlen + p) / 4
    mov r8d, dword[LINK_ID_GENERATOR]
    mov dword[rsp + 4], r8d ; set font_id
    inc dword[LINK_ID_GENERATOR]
    mov ebx, r8d
    mov word[rsp + 8], r14w
    xor rcx, rcx
    .copy_name:
        cmp rcx, r14
        je .bye_copy_name
        mov r8b, byte[r13 + rcx]
        mov byte[rsp + 12 + rcx], r8b
        inc rcx
        jmp .copy_name

    .bye_copy_name:
    mov rax, 1
    mov rdi, qword[LINK_SOCKET]
    lea rsi, [rsp]
    mov rdx, r15
    syscall
    neg r15
    and r15, -8
    neg r15
    add rsp, r15
    cmp rax, rdx
    jne .bye_error

    mov rdi, 12
    call AsmAlloc
    cmp rax, 0
    je .bye_error

    mov dword[rax], ebx
    mov qword[rax + 4], r12

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

    .bye_error:
        pop r15
        pop r14
        pop r13
        pop r12
        pop rbx
    .bye_error0:
        xor rax, rax
        ret