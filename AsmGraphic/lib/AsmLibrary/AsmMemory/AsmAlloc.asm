section .data
    malloc_bug db "AsmAlloc(): memory allocation failed", 10

section .text
    global AsmAlloc
    %include "AsmLibrary.inc"

AsmAlloc:
    push rdi
    lea rdi, [rel AsmFutexMemory]
    call AsmLock
    pop rdi
    cmp rdi, 0
    je .bug ; check if size wanted is null
    push rdi
    cmp qword[rel AsmCoreMemory], -1
    jne .unprotect ; if page exist unprotect it

    .init_page:
        mov rax, 9 ; mmap
        mov rdi, 0 ; random addr
        mov rsi, 4096 ; page length
        mov rdx, 3 ; can read | write
        mov r10, 34 ; anonymous | private
        mov r8, -1 ; on memory
        mov r9, 0 ; no offset
        syscall ; create the initial page
        cmp rax, 0
        jl .bug_1

        mov qword[rel AsmCoreMemory], rax ; set the page in AsmCoreMemory
        mov rcx, 512
        .init_zero_page:
            mov qword[rax - 8 + rcx * 8], 0
            loop .init_zero_page
        jmp .alloc
    .unprotect:
        mov r10, qword[rel AsmCoreMemory] ; get page
        mov rsi, 4096 ; set page size
        mov rdx, 3 ; set unprotect mode
        .loop_unprotect:
            mov rax, 10 ; mprotect
            mov rdi, r10 ; page
            syscall
            cmp rax, 0
            jl .bug_1
            mov r10, qword[r10] ; set next page
            cmp r10, 0
            jne .loop_unprotect ; go next page if there is one
    .alloc:
    pop r8 ; get size wanted
    mov r10, qword[rel AsmCoreMemory] ; get page
    mov r11, -1 ; set offset
    .find_space:
        add r11, 17 ; go to next alloc
        cmp r11, 4096
        je .next_page ; if page end go next page
        cmp byte[r10 + r11 + 16], 1
        je .find_space ; if alloc is owned go next alloc
        cmp qword[r10 + r11], 0
        je .new_alloc ; if alloc is empty go create alloc
        cmp qword[r10 + r11], r8
        jl .find_space ; if alloc free is to small go next alloc
        jmp .split_alloc
    .new_alloc:
        push r8
        push r10
        push r11
        mov rax, 9 ; mmap
        mov rdi, 0 ; random addr
        mov rsi, r8 ; length round to 4096
        mov rdx, 3 ; can read | write
        mov r10, 34 ; anonymous | private
        mov r8, -1 ; on memory
        mov r9, 0 ; no offset
        syscall ; create alloc
        pop r11
        pop r10
        pop r8
        cmp rax, 0
        jl .bug

        mov r9, rax ; set alloc addr
        mov rax, r8 ; round r8 to nearest 4096 multiple
        neg rax
        and rax, -4096
        neg rax

        mov qword[r10 + r11], rax ; set alloc length
        mov qword[r10 + r11 + 8], r9 ; set alloc addr
    
    .split_alloc:
        mov byte[r10 + r11 + 16], 1 ;  set alloc state at owned
        mov rdi, qword[r10 + r11 + 8]
        push rdi ; save alloc for return
        cmp qword[r10 + r11], r8
        je .protect ; if alloc wanted = alloc free leave the function
        mov rsi, qword[r10 + r11]
        sub rsi, r8
        mov qword[r10 + r11], r8 ; set new alloc size
        push rsi ; save split length
        .find_last_space:
            add r11, 17
            cmp r11, 4096
            je .next_page2
            cmp qword[r10 + r11], 0
            jne .find_last_space
        .leave_find_last_space:
        pop rsi ; restore split length
        pop rdi ; restore alloc addr
        push rdi
        add rdi, r8 ; go to split addr
        mov qword[r10 + r11], rsi ; set split length
        mov qword[r10 + r11 + 8], rdi ; set split addr
        mov byte[r10 + r11 + 16], 0 ; set state at free

    .protect:
        mov r10, qword[rel AsmCoreMemory] ; get page
        mov rsi, 4096 ; set page size
        mov rdx, 1 ; set protect mode
        .loop_protect:
            mov rax, 10 ; mprotect
            mov rdi, r10 ; page
            syscall
            cmp rax, 0
            jl .bug_1
            mov r10, qword[r10] ; set next page
            cmp r10, 0
            jne .loop_protect ; go next page if there is one
    .bye:
    lea rdi, [rel AsmFutexMemory]
    call AsmUnlock
    pop rax ; get alloc addr
    ret

    .bug_1:
        pop rdi
    .bug:
        mov rax, 1
        mov rdi, 2
        lea rsi, [rel malloc_bug]
        mov rdx, 37
        syscall
        lea rdi, [rel AsmFutexMemory]
        call AsmUnlock
        xor rax, rax
        ret

    .next_page:
        cmp qword[r10], 0
        je .create_page
        mov r10, qword[r10]
        mov r11, -1
        jmp .find_space
    .create_page:
        push r8
        push r10
        mov rax, 9
        xor rdi, rdi
        mov rsi, 4096
        mov rdx, 3
        mov r10, 34
        mov r8, -1
        xor r9, r9
        syscall
        pop r10
        pop r8
        cmp rax, 0
        jl .bug

        mov qword[r10], rax
        mov r10, rax
        mov rcx, 512
        .zero_page:
            mov qword[r10 - 8 + rcx * 8], 0
            loop .zero_page
        mov r11, 16
        jmp .new_alloc

    .next_page2:
        cmp qword[r10], 0
        je .create_page2
        mov r10, qword[r10]
        mov r11, -1
        jmp .find_last_space
    .create_page2:
        push r8
        push r10
        mov rax, 9
        xor rdi, rdi
        mov rsi, 4096
        mov rdx, 3
        mov r10, 34
        mov r8, -1
        xor r9, r9
        syscall
        pop r10
        pop r8
        cmp rax, 0
        jl .bug_1

        mov qword[r10], rax
        mov r10, rax
        mov rcx, 512
        .zero_page2:
            mov qword[r10 - 8 + rcx * 8], 0
            loop .zero_page2
        mov r11, 16
        jmp .leave_find_last_space