section .data
    free_error db "AsmDalloc(): invalid pointer", 10
    free_bug db "AsmDalloc(): memory release failed", 10
section .text
    global AsmDalloc
    %include "AsmLibrary.inc"

AsmDalloc:
    push rdi
    lea rdi, [rel AsmFutexMemory]
    call AsmLock
    pop rdi
    cmp rdi, 0
    je .bye
    cmp qword[rel AsmCoreMemory], -1
    je .error
    push r12
    push r13
    push r14
    push r15
    push rdi
    .unprotect:
        mov r10, qword[rel AsmCoreMemory] ; get page
        mov rsi, 4096 ; set page size
        mov rdx, 3 ; set unprotect mode
        .loop_unprotect:
            mov rax, 10 ; mprotect
            mov rdi, r10 ; page
            syscall
            cmp rax, 0
            jl .bug
            mov r10, qword[r10] ; set next page
            cmp r10, 0
            jne .loop_unprotect ; go next page if there is one

    .dalloc:
    pop rdi ; restore addr to free
    xor r12, r12
    xor r13, r13
    xor r14, r14
    mov r10, qword[rel AsmCoreMemory] ; set index
    mov r11, r10
    add r11, 4096 ; set page limit
    add r10, -1
    .find_alloc:
        add r10, 17 ; increase to next alloc
        cmp r10, r11
        je .next_page ; if limit reach go next page
        cmp qword [r10], 0
        je .leave_find_alloc ; if last alloc go free
        cmp qword [r10 + 8], rdi
        cmove r12, r10 ; if its the alloc to free save it
        mov r13, r14 ; last last alloc save
        mov r14, r10 ; last alloc save
        jmp .find_alloc
        .next_page:
            cmp qword [r10 - 4096], 0
            je .leave_find_alloc ; if last alloc go free
            mov r10, qword [r10 - 4096] ; set index
            mov r11, r10
            add r11, 4096 ; set page limit
            add r10, -1
            jmp .find_alloc ; go find last alloc

    .leave_find_alloc:
    cmp r12, 0
    je .error ; check if alloc find
    cmp byte[r12 + 16], 0
    je .error ; check if alloc is owned
    mov byte[r12 + 16], 0 ; set alloc to free
    mov r10, qword[rel AsmCoreMemory] ; set to first alloc
    mov r11, -1
    .find_prev:
        add r11, 17 ; increase to next alloc
        cmp r11, 4096
        je .next_page_prev ; if limit reach go next page
        cmp qword[r10 + r11], 0
        je .leave_find_prev ; if last alloc go find next
        cmp byte[r10 + r11 + 16], 1
        je .find_prev ; if owned go next alloc
        mov rdi, qword[r10 + r11 + 8]
        add rdi, qword[r10 + r11]
        cmp qword[r12 + 8], rdi
        jne .find_prev ; check if this alloc is the prev
        mov rdi, qword[r12]
        add qword[r10 + r11], rdi ; set the new length of prev
        jmp .swap_prev ; go push alloc to end of list
        .next_page_prev:
            cmp qword[r10], 0
            je .leave_find_prev ; if last alloc go find next
            mov r10, qword[r10]
            mov r11, -1 ; set index
            jmp .find_prev ; go find prev
        .swap_prev:
            mov rdi, qword[r14]
            mov qword[r12], rdi
            mov rdi, qword[r14 + 8]
            mov qword[r12 + 8], rdi
            movzx rdi, byte[r14 + 16]
            mov byte[r12 + 16], dil
            mov qword[r14], 0
            mov qword[r14 + 8], 0
            mov byte[r14 + 16], 0 ; swap last and alloc
            mov rsi, r10
            add rsi, r11 ; get prev addr
            cmp r14, rsi
            cmovne r12, rsi ; if prev is not last set alloc to prev
            mov r14, r13 ; set last last save to last save

    .leave_find_prev:
    mov r10, qword[rel AsmCoreMemory] ; set to first alloc
    mov r11, -1
    mov rdi, qword[r12 + 8]
    add rdi, qword[r12] ; set the cmp for see if its next
    .find_next:
        add r11, 17 ; increase to next alloc
        cmp r11, 4096
        je .next_page_next ; if limit reach go next page
        cmp qword[r10 + r11], 0
        je .leave_find_next ; if last alloc go find next
        cmp byte[r10 + r11 + 16], 1
        je .find_next ; if owned go next alloc
        cmp qword[r10 + r11 + 8], rdi
        jne .find_next ; check if this alloc is the next
        mov rdi, qword[r10 + r11]
        add qword[r12], rdi ; set the new length of alloc
        jmp .swap_next ; go push alloc to end of list
        .next_page_next:
            cmp qword[r10], 0
            je .leave_find_next ; if last alloc go find next
            mov r10, qword[r10]
            mov r11, -1 ; set index
            jmp .find_next ; go find next
        .swap_next:
            mov rdi, qword[r14]
            mov qword[r10 + r11], rdi
            mov rdi, qword[r14 + 8]
            mov qword[r10 + r11 + 8], rdi
            movzx rdi, byte[r14 + 16]
            mov byte[r10 + r11 + 16], dil
            mov qword[r14], 0
            mov qword[r14 + 8], 0
            mov byte[r14 + 16], 0 ; swap last and next

    .leave_find_next:
    .protect:
        mov r10, qword[rel AsmCoreMemory] ; get page
        mov rsi, 4096 ; set page size
        mov rdx, 1 ; set protect mode
        .loop_protect:
            mov rax, 10 ; mprotect
            mov rdi, r10 ; page
            syscall
            cmp rax, 0
            jl .bug
            mov r10, qword[r10] ; set next page
            cmp r10, 0
            jne .loop_protect ; go next page if there is one
    .bye:
    pop r15
    pop r14
    pop r13
    pop r12
    lea rdi, [rel AsmFutexMemory]
    call AsmUnlock
    ret

    .error:
        mov rax, 1
        mov rdi, 2
        lea rsi, [rel free_error]
        mov rdx, 29
        syscall
        mov rax, 39
        syscall
        lea rdi, [rel AsmFutexMemory]
        call AsmUnlock
        mov rdi, rax
        mov rsi, 6
        mov rax, 62
        syscall
        ret

    .bug:
        mov rax, 1
        mov rdi, 2
        lea rsi, [rel free_bug]
        mov rdx, 35
        syscall
        mov rax, 39
        syscall
        lea rdi, [rel AsmFutexMemory]
        call AsmUnlock
        mov rdi, rax
        mov rsi, 6
        mov rax, 62
        syscall
        ret