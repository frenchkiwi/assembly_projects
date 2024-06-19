    global AsmMemset
    global AsmMemcpy
    global AsmMemmove
    global AsmAlloc
    global AsmDalloc
    global AsmCalloc
    global AsmRealloc
    global AsmStrdup
    global AsmGetptr
    global AsmShowMemory
    %include "AsmLibrary.inc"

section .data
    malloc_base dq -1 ; 8octet for next_malloc_page | 8octet free to use | 240 node of (8octet for size of allocation | 8octet for addr of allocation | 1octet for allocation state (1 = owned | 0 = free))
    malloc_bug db "AsmAlloc(): memory allocation failed", 10
    free_error db "AsmDalloc(): invalid pointer", 10
    free_bug db "AsmDalloc(): memory release failed", 10

section .text

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

AsmMemcpy:
     mov rcx, -1
    .loop:
        inc rcx
        cmp rdx, rcx
        je .bye
        mov r8b, byte[rsi + rcx]
        mov byte[rdi + rcx], r8b
        jmp .loop
    .bye:
    mov rax, rdi
    ret

AsmMemmove:
    cmp rdx, 0
    je .bye
    mov r8, rdx
    neg r8
    and r8, -8
    neg r8
    sub rsp, r8
    mov rcx, 0
    .copy:
        mov r9b, byte[rsi + rcx]
        mov byte[rsp + rcx], r9b
        inc rcx
        cmp rcx, rdx
        jne .copy
    mov rcx, 0
    .paste:
        mov r9b, byte[rsp + rcx]
        mov byte[rdi + rcx], r9b
        inc rcx
        cmp rcx, rdx
        jne .paste
    add rsp, r8
    .bye
    ret

AsmAlloc:
    cmp rdi, 0
    je .bug ; check if size wanted is null
    push rdi
    cmp qword[rel malloc_base], -1
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

        mov qword[rel malloc_base], rax ; set the page in malloc_base
        mov rcx, 512
        .init_zero_page:
            mov qword[rax - 8 + rcx * 8], 0
            loop .init_zero_page
        jmp .alloc
    .unprotect:
        mov r10, qword[rel malloc_base] ; get page
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
    mov r10, qword[rel malloc_base] ; get page
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
        mov r10, qword[rel malloc_base] ; get page
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

AsmDalloc:
    cmp rdi, 0
    je .bye
    cmp qword[rel malloc_base], -1
    je .error
    push r12
    push r13
    push r14
    push r15
    push rdi
    .unprotect:
        mov r10, qword[rel malloc_base] ; get page
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
    mov r10, qword[rel malloc_base] ; set index
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
    mov r10, qword[rel malloc_base] ; set to first alloc
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
            push qword[r14 + 8] ; save last addr
            mov rdi, qword[r14]
            mov qword[r12], rdi
            mov rdi, qword[r14 + 8]
            mov qword[r12 + 8], rdi
            movzx rdi, byte[r14 + 16]
            mov byte[r12 + 16], dil
            mov qword[r14], 0
            mov qword[r14 + 8], 0
            mov byte[r14 + 16], 0 ; swap last and alloc
            pop rdi ; restore last addr
            mov rsi, r10
            add rsi, r11 ; get prev addr
            cmp rdi, qword[r10 + r11 + 8]
            cmovne r12, rsi ; if prev is not last set alloc to prev
            mov r14, r13 ; set last last save to last save

    .leave_find_prev:
    mov r10, qword[rel malloc_base] ; set to first alloc
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
        mov r10, qword[rel malloc_base] ; get page
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
    ret

    .error:
        mov rax, 1
        mov rdi, 2
        lea rsi, [rel free_error]
        mov rdx, 29
        syscall
        mov rax, 39
        syscall
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
        mov rdi, rax
        mov rsi, 6
        mov rax, 62
        syscall
        ret

AsmCalloc:
    push rdi
    push rsi
    call AsmAlloc
    pop rsi
    pop rdi
    cmp rax, 0
    je .bye
    xor rcx, rcx
    .loop:
        mov byte [rax + rcx], sil
        inc rcx
        cmp rcx, rdi
        jne .loop
    .bye:
    ret

AsmRealloc:
    push rsi
    cmp rdi, 0
    je .no_free
    call AsmDalloc
    .no_free:
    pop rdi
    cmp rdi, 0
    je .no_malloc
    call AsmAlloc
    .no_malloc:
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

AsmGetptr:
    push rdi
    mov rdi, 8
    call AsmAlloc
    pop rdi
    cmp rax, 0
    je .bye
    mov qword[rax], rdi
    .bye:
    ret

AsmShowMemory:
    push r12
    push r13
    mov rdi, 'g'
    call AsmPutchar
    mov rdi, 'o'
    call AsmPutchar
    mov rdi, 10
    call AsmPutchar
    cmp qword [rel malloc_base], -1
    je .bye
    .unprotect:
        mov r12, qword [rel malloc_base] ; get page
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
    mov r12, qword [rel malloc_base]
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
        mov r12, qword [rel malloc_base] ; get page
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
    