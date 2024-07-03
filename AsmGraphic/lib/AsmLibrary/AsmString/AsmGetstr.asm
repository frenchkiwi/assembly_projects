section .data

section .text
    global AsmGetstr
    %include "AsmLibrary.inc"

AsmGetstr:
    push rbx
    push r12
    push r13
    push r14
    mov r13, rdi
    mov r12, rdi
    xor rdi, rdi
    cmp r12, 0
    jge .setup
    inc rdi
    neg r12
    .setup:
    mov r14, 1
    mov rbx, 10
    .loop_len:
        inc rdi

        mov rax, r14
        mul rbx

        mov r14, rax
        mov rax, r12
        xor rdx, rdx
        div r14

        cmp rax, 1
        jge .loop_len
    inc rdi
    call AsmAlloc
    mov r12, rax
    mov rcx, -1
    cmp r13, 0
    jge .loop
    mov byte[r12], '-'
    inc rcx
    neg r13
    .loop:
        inc rcx

        mov rax, r14
        xor rdx, rdx
        div rbx
        mov r14, rax

        mov rax, r13
        xor rdx, rdx
        div r14

        mov r13, rdx
        add rax, '0'
        mov byte[r12 + rcx], al

        cmp r13, 0
        jne .loop
    mov byte[r12 + rcx + 1], 0
    mov rax, r12
    pop r14
    pop r13
    pop r12
    pop rbx
    ret