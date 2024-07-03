section .data

section .text
    global AsmStrdup
    %include "AsmLibrary.inc"

AsmStrdup:
    xor rax, rax
    cmp rdi, 0
    je .bye
    push r12
    push r13
    mov rcx, -1
    .loop:
        inc rcx
        cmp byte[rdi + rcx], 0
        jne .loop
    inc rcx
    mov r12, rdi
    mov r13, rcx
    mov rdi, rcx
    call AsmAlloc
    cmp rax, 0
    je .leave_copy
    .copy:
        dec r13
        mov sil, byte[r12 + r13]
        mov byte[rax + r13], sil
        cmp r13, 0
        jne .copy
    .leave_copy:
    pop r13
    pop r12
    .bye:
    ret