    global AsmPutchar
    global AsmPutstr
    global AsmPutnbr
    global AsmStrdup
    global AsmStrcpy
    global AsmStrncpy
    global AsmPrint
    %include "AsmLibrary.inc"

section .data

section .text
AsmPutchar:
    sub rsp, 8
    
    mov byte[rsp], dil

    mov rax, 1
    mov rdi, 1
    lea rsi, [rsp]
    mov rdx, 1
    syscall

    movzx rax, byte[rsp]

    add rsp, 8
    ret

AsmPutstr:
    cmp rdi, 0
    je .bye
    lea rsi, [rdi]
    mov rdx, -1
    .loop:
        inc rdx
        cmp byte [rsi + rdx], 0
        jne .loop
    mov rax, 1
    mov rdi, 1
    syscall
    .bye:
    ret

AsmPutnbr:
    push r12
    push r13
    push r14
    mov r12, rdi
    cmp r12, 0
    jge .no_neg
        mov rdi, '-'
        call AsmPutchar
        neg r12
    .no_neg:

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
        jge .loop_len
    
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
    ret

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
    .copy:
        dec r13
        mov sil, byte[r12 + r13]
        mov byte[rax + r13], sil
        cmp r13, 0
        jne .copy
    pop r13
    pop r12
    .bye:
    ret

AsmStrcpy:
    mov rcx, -1
    .loop:
        inc rcx
        mov r8b, byte[rsi + rcx]
        mov byte[rdi + rcx], r8b
        cmp byte[rsi + rcx], 0
        jne .loop
    mov rax, rdi
    ret

AsmStrncpy:
    mov rcx, -1
    .loop:
        inc rcx
        cmp rdx, rcx
        je .bye
        mov r8b, byte[rsi + rcx]
        mov byte[rdi + rcx], r8b
        cmp byte[rsi + rcx], 0
        jne .loop
    .bye:
    mov byte [rdi + rcx], 0
    mov rax, rdi
    ret

AsmPrint:
    cmp rdi, 0
    je .bye
    push r9
    push r8
    push rcx
    push rdx
    push rsi
    push rbp
    mov rbp, rsp
    push rbx
    push r12 ; String adress
    push r13 ; Counter
    push r14 ; Param counter
    push r15

    mov r12, rdi
    mov r13, -1
    mov r14, 8
    .loop:
        inc r13
        movzx rdi, byte[r12 + r13]
        cmp rdi, '%'
        je .analyze_flag
        call AsmPutchar
        .back_analyze_flag:
        cmp byte[r12 + r13], 0
        jne .loop
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    pop rsi
    pop rdx
    pop rcx
    pop r8
    pop r9
    .bye:
    ret

    .analyze_flag:
        cmp byte[r12 + r13 + 1], 'c'
        je .c_flag
        cmp byte[r12 + r13 + 1], 'd'
        je .d_flag
        cmp byte[r12 + r13 + 1], 's'
        je .s_flag
        cmp byte[r12 + r13 + 1], '%'
        je .p_flag
        call AsmPutchar
        jmp .back_analyze_flag
        
    .next_param:
        add r14, 8
        cmp r14, 48
        je .next_param
        jmp .back_analyze_flag

    .c_flag:
        mov rdi, qword[rbp + r14]
        call AsmPutchar
        inc r13
        jmp .next_param

    .d_flag:
        mov rdi, qword[rbp + r14]
        call AsmPutnbr
        inc r13
        jmp .next_param
    
    .s_flag:
        mov rdi, qword[rbp + r14]
        call AsmPutstr
        inc r13
        jmp .next_param
    .p_flag:
        call AsmPutchar
        inc r13
        jmp .next_param