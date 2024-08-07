section .data

section .text
    global AsmPutunbr
    %include "AsmLibrary.inc"

AsmPutunbr:
    push rbx
    push r12
    push r13
    push r14
    mov r12, rdi
    mov r13, 0
    mov r14, 1
    mov rbx, 10
    .loop_len:
        inc r13

        mov rax, r14
        mul rbx

        mov r14, rax
        mov rax, r12
        xor rdx, rdx
        div r14

        cmp rax, 1
        jae .loop_len
    
    .loop:
        dec r13

        mov rax, r14
        xor rdx, rdx
        div rbx
        mov r14, rax

        mov rax, r12
        xor rdx, rdx
        div r14

        mov r12, rdx
        add rax, '0'
        mov rdi, rax
        call AsmPutchar

        cmp r13, 0
        jne .loop
    pop r14
    pop r13
    pop r12
    pop rbx
    ret