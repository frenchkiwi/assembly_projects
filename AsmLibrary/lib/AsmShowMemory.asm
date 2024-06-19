section .data

section .text
    global AsmShowMemory
    %include "AsmLibrary.inc"

AsmShowMemory:
    push r12
    push r13
    mov rdi, 'g'
    call AsmPutchar
    mov rdi, 'o'
    call AsmPutchar
    mov rdi, 10
    call AsmPutchar
    cmp qword [rel AsmCoreMemory], -1
    je .bye
    .unprotect:
        mov r12, qword [rel AsmCoreMemory] ; get page
        mov rsi, 4096 ; set page size
        mov rdx, 3 ; set unprotect mode
        .loop_unprotect:
            mov rax, 10 ; mprotect
            mov rdi, r12 ; page
            syscall
            cmp rax, 0
            jl .bye
            mov r12, qword [r12] ; set next page
            cmp r12, 0
            jne .loop_unprotect ; go next page if there is one
    mov r12, qword [rel AsmCoreMemory]
    mov r13, -1
    .find_space:
        add r13, 17
        cmp r13, 4096
        jge .next_page
        cmp qword[r12 + r13], 0
        je .protect
        mov rdi, 's'
        call AsmPutchar
        mov rdi, ':'
        call AsmPutchar
        mov rdi, qword[r12 + r13]
        call AsmPutnbr
        mov rdi, 32
        call AsmPutchar
        mov rdi, 'a'
        call AsmPutchar
        mov rdi, ':'
        call AsmPutchar
        mov rdi, qword[r12 + r13 + 8]
        call AsmPutnbr
        mov rdi, 32
        call AsmPutchar
        mov rdi, 'e'
        call AsmPutchar
        mov rdi, ':'
        call AsmPutchar
        movzx rdi, byte[r12 + r13 + 16]
        call AsmPutnbr
        mov rdi, 10
        call AsmPutchar
        jmp .find_space
    .protect:
        mov r12, qword [rel AsmCoreMemory] ; get page
        mov rsi, 4096 ; set page size
        mov rdx, 1 ; set protect mode
        .loop_protect:
            mov rax, 10 ; mprotect
            mov rdi, r12 ; page
            syscall
            cmp rax, 0
            jl .bye
            mov r12, qword [r12] ; set next page
            cmp r12, 0
            jne .loop_protect ; go next page if there is one
    .bye:
    pop r13
    pop r12
    ret

    .next_page:
        cmp qword [r12], 0
        je .protect
        mov rdi, 'n'
        call AsmPutchar
        mov rdi, 'p'
        call AsmPutchar
        mov rdi, 10
        call AsmPutchar
        mov r12, qword [r12]
        mov r13, -1
        jmp .find_space