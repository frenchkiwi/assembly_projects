    global AsmPutchar
    global AsmPutstr
    global AsmPutlstr
    global AsmPutnbr
    global AsmPutlnbr
    global AsmStrlen
    global AsmStrcpy
    global AsmStrncpy
    global AsmStrcmp
    global AsmStrncmp
    global AsmStrcasecmp
    global AsmStrcat
    global AsmStrncat
    global AsmStrchr
    global AsmStrrchr
    global AsmStrpbrk
    global AsmStrcspn
    global AsmStrstr
    global AsmMemset
    global AsmPrint
    global AsmStrcut
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
    mov rsi, rdi
    mov rdx, -1
    .loop:
        inc rdx
        cmp byte[rsi + rdx], 0
        jne .loop
    mov rax, 1
    mov rdi, 1
    syscall
    .bye:
    ret

AsmPutlstr:
    cmp rdi, 0
    je .bye
    mov rsi, rdi
    mov rdx, -1
    .loop:
        inc rdx
        cmp byte[rsi + rdx], 0
        jne .loop
    inc rdx
    mov rax, 1
    mov rdi, 1
    syscall
    mov rdi, 10
    call AsmPutchar
    .bye:
    ret

AsmPutnbr:
    push rbx
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
    pop rbx
    ret

AsmPutlnbr:
    push rbx
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
    pop rbx
    mov rdi, 10
    call AsmPutchar
    ret

AsmStrlen:
    mov rax, -1
    .loop:
        inc rax
        cmp byte [rdi + rax], 0
        jne .loop
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

AsmStrcmp:
    mov rcx, -1
    .loop:
        inc rcx
        mov r8b, byte[rsi + rcx]
        cmp byte[rdi + rcx], r8b
        jne .not_equal
        cmp byte[rdi + rcx], 0
        jne .loop
    xor rax, rax
    ret
    .not_equal:
        movzx rax, byte[rdi + rcx]
        movzx rdx, byte[rsi + rcx]
        sub rax, rdx
        ret

AsmStrncmp:
    mov rcx, -1
    .loop:
        inc rcx
        cmp rdx, rcx
        je .bye
        mov r8b, byte[rsi + rcx]
        cmp byte[rdi + rcx], r8b
        jne .not_equal
        cmp byte[rdi + rcx], 0
        jne .loop
    .bye:
    xor rax, rax
    ret
    .not_equal:
        movzx rax, byte[rdi + rcx]
        movzx rdx, byte[rsi + rcx]
        sub rax, rdx
        ret

AsmStrcasecmp:
    mov rcx, -1
    .loop:
        inc rcx
        movzx r8, byte[rdi + rcx]
        .check_case:
            cmp r8, 'A'
            jl .leave_check_case
            cmp r8, 'Z'
            jg .leave_check_case
            add r8, 32
        .leave_check_case:
        movzx r9, byte[rsi + rcx]
        .check_case2:
            cmp r9, 'A'
            jl .leave_check_case2
            cmp r9, 'Z'
            jg .leave_check_case2
            add r9, 32
        .leave_check_case2:
        cmp r8, r9
        jne .not_equal
        cmp r8, 0
        jne .loop
    xor rax, rax
    ret
    .not_equal:
        mov rax, r8
        sub rax, r9 
        ret

AsmStrcat:
    .goto_end:
        cmp byte[rdi], 0
        je .leave_goto_end
        inc rdi
        jmp .goto_end
    .leave_goto_end:
    mov rcx, -1
    .loop:
        inc rcx
        mov r8b, byte[rsi + rcx]
        mov byte[rdi + rcx], r8b
        cmp r8b, 0
        jne .loop
    mov rax, rdi
    ret

AsmStrncat:
    .goto_end:
        cmp byte[rdi], 0
        je .leave_goto_end
        inc rdi
        jmp .goto_end
    .leave_goto_end:
    mov rcx, -1
    .loop:
        inc rcx
        cmp rdx, rcx
        je .bye
        mov r8b, byte[rsi + rcx]
        mov byte[rdi + rcx], r8b
        cmp r8b, 0
        jne .loop
    .bye:
    mov byte[rdi + rcx], 0
    mov rax, rdi
    ret

AsmStrchr:
    dec rdi
    .loop:
        inc rdi
        cmp byte[rdi], sil
        je .return_here
        cmp byte[rdi], 0
        jne .loop
    xor rax, rax
    ret

    .return_here:
        mov rax, rdi
        ret

AsmStrrchr:
    dec rdi
    xor rax, rax
    .loop:
        inc rdi
        cmp byte[rdi], sil
        cmove rax, rdi
        cmp byte[rdi], 0
        jne .loop
    ret

AsmStrpbrk:
    dec rdi
    .loop:
        inc rdi
        mov rcx, -1
        .in_list:
            inc rcx
            mov r8b, byte[rsi + rcx]
            cmp byte[rdi], r8b
            je .return_here
            cmp r8b, 0
            jne .in_list
        cmp byte[rdi], 0
        jne .loop
    xor rax, rax
    ret

    .return_here:
        mov rax, rdi
        ret

AsmStrcspn:
    mov rdx, -1
    .loop:
        inc rdx
        mov rcx, -1
        .in_list:
            inc rcx
            mov r8b, byte[rsi + rcx]
            cmp byte[rdi + rdx], r8b
            je .return_here
            cmp r8b, 0
            jne .in_list
        cmp byte[rdi + rdx], 0
        jne .loop
    xor rax, rax
    ret

    .return_here:
        mov rax, rdx
        ret

AsmStrstr:
    dec rdi
    movzx r9, byte[rsi]
    .loop:
        inc rdi
        cmp byte[rdi], r9b
        jne .not_find
        mov rcx, -1
        .loop_cmp:
            inc rcx
            cmp byte[rsi + rcx], 0
            cmove rax, rdi
            je .bye
            mov r8b, byte[rsi + rcx]
            cmp byte[rdi + rcx], r8b
            jne .not_find
            cmp byte[rdi + rcx], 0
            jne .loop_cmp
        .not_find:
        cmp byte[rdi], 0
        jne .loop
    xor rax, rax
    .bye:
    ret

AsmMemset:
    cmp rdx, 0
    je .bye
    mov rcx, 0
    .loop:
        mov byte[rdi + rcx], sil
        inc rcx
        cmp rcx, rdx
        jne .loop
    .bye:
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

AsmStrcut:
    push r12 ; result addr
    push r13 ; word counter
    push r14 ; index
    push r15 ; state
    xor r12, r12
    cmp rdi, 0
    je .bye
    cmp rsi, 0
    je .bye
    mov r13, 1 ; set word counter at 1 for the NULL word
    mov r14, -1 ; set index
    mov r15, 0 ; set state
    .count_word:
        inc r14 ; increase index
        mov r8, -1 ; set index for delimiters
        .loop_count_word:
            inc r8 ; increase index for delimiters
            mov r9b, byte[rdi + r14]
            cmp byte[rsi + r8], r9b ; cmp the actual char with actual delimiter
            je .add_word_count_word ; if actual char is a delimiter than go add word
            cmp byte[rsi + r8], 0 ; loop if delimiter str '\0' not reach
            jne .loop_count_word
        mov r15, 1 ; if not a delimiter set state
        jmp .go_next_count_word ; go next char
        .add_word_count_word:
            cmp r15, 1 ; check if its a new word
            jne .go_next_count_word ; if no go next char
            mov r15, 0 ; if new word set state
            inc r13 ; increase word counter
        .go_next_count_word:
        cmp byte[rdi + r14], 0 ; loop if str '\0' not reach 
        jne .count_word
    mov rax, r13 
    mov rdx, 8
    mul rdx ; multiply word counter by 8 for size alloc
    push rdi
    push rsi
    mov rdi, rax
    call AsmAlloc ; allocate the word
    mov r12, rax ; save addr
    pop rsi
    pop rdi
    cmp rax, 0
    je .bye
    mov qword[r12 + r13], 0 ; set NULL word
    mov r13, 0 ; r13 is now the index word
    mov r14, -1 ; set index
    mov r15, 0 ; set state
    .set_word:
        inc r14 ; increase index
        mov r8, -1 ; set index for delimiters
        .loop:
            inc r8 ; increase index for delimiters
            mov r9b, byte[rdi + r14]
            cmp byte[rsi + r8], r9b ; cmp the actual char with actual delimiter
            je .add_word ; if actual char is a delimiter than go add word
            cmp byte[rsi + r8], 0 ; loop if delimiter str '\0' not reach
            jne .loop
        inc r15 ; if not a delimiter set state
        jmp .go_next ; go next char
        .add_word:
            cmp r15, 0 ; check if its a new word
            je .go_next ; if no go next char
            push rsi ; save rsi
            push rdi ; save rdi
            mov rdi, r15 ; set the length for allocate the word
            inc rdi ; +1 for the '\0'
            call AsmAlloc ; allocate the word
            mov qword[r12 + r13 * 8], rax ; set the allocate memory in the array
            mov rdi, rax ; set the dest for AsmStrncpy
            pop rsi ; get the string
            pop rdx ; get element on stack for check error
            cmp rax, 0
            je .bye
            push rdx ; replace the element
            push rsi ; replace the string on stack
            add rsi, r14 ; go to the end of the word
            sub rsi, r15 ; go to the start of the word
            mov rdx, r15 ; set the copy length
            call AsmStrncpy ; copy the word in the allocate memory
            pop rdi ; restore rdi
            pop rsi ; restore rsi
            inc r13 ; increase word index
            mov r15, 0 ; if new word set state
        .go_next:
        cmp byte[rdi + r14], 0 ; loop if str '\0' not reach 
        jne .set_word
    .bye:
    mov rax, r12 ; set the result
    pop r15
    pop r14
    pop r13
    pop r12
    ret