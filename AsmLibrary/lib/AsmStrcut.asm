section .data

section .text
    global AsmStrcut
    %include "AsmLibrary.inc"
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