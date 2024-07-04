section .data

section .text
    global AsmPrint
    %include "AsmLibrary.inc"

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
    push r12 ; String adress
    push r13 ; Counter
    push r14 ; Param counter

    mov r12, rdi
    mov r13, -1
    mov r14, 8
    cmp byte[r12], 0
    je .leave_loop
    .loop:
        inc r13
        movzx rdi, byte[r12 + r13]
        cmp rdi, '%'
        je .analyze_flag
        call AsmPutchar
        .back_analyze_flag:
        cmp byte[r12 + r13 + 1], 0
        jne .loop
    .leave_loop:
    pop r14
    pop r13
    pop r12
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
        cmp byte[r12 + r13 + 1], 'b'
        je .b_flag
        cmp byte[r12 + r13 + 1], 'w'
        je .w_flag
        cmp byte[r12 + r13 + 1], 'd'
        je .d_flag
        cmp byte[r12 + r13 + 1], 'q'
        je .q_flag
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

    .b_flag:
        mov rdi, qword[rbp + r14]
        movsx di, dil
        movsx edi, di
        movsx rdi, edi
        call AsmPutnbr
        inc r13
        jmp .next_param

    .w_flag:
        mov rdi, qword[rbp + r14]
        movsx edi, di
        movsx rdi, edi
        call AsmPutnbr
        inc r13
        jmp .next_param

    .d_flag:
        mov rdi, qword[rbp + r14]
        movsx rdi, edi
        call AsmPutnbr
        inc r13
        jmp .next_param
    
    .q_flag:
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