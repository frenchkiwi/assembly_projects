    global AsmAlloc
    global AsmDalloc
    global AsmCalloc
    global AsmRealloc
    global AsmStrdup
    global AsmShowMemory
    %include "AsmLibrary.inc"

section .data
    malloc_base dq -1
    malloc_bug db "AsmAlloc(): memory allocation failed", 10
    free_error db "AsmDalloc(): invalid pointer", 10
    free_bug db "AsmDalloc(): bug memory release", 10

section .text
AsmAlloc:
    cmp rdi, 0
    jle .malloc_error
    push rdi
    mov r10, qword [rel malloc_base]
    cmp r10, -1
    je .init_malloc_page
    .unprotect:
        mov rax, 10
        mov rdi, r10
        mov rsi, 4096
        mov rdx, 3
        syscall
        cmp rax, 0
        jl .malloc_error2
        cmp qword [r10], 0
        je .alloc
        mov r10, qword [r10]
        jmp .unprotect
    .alloc:
    pop rdi
    mov r8, rdi

    mov r10, qword [rel malloc_base]
    mov r11, -1
    .find_space:
        add r11, 17
        cmp r11, 4096
        jge .go_next_malloc_page
        cmp qword [r10 + r11], 0
        je .continue_find_space
        cmp byte [r10 + r11 + 16], 1
        je .find_space
        cmp qword [r10 + r11], r8
        jl .find_space
    .continue_find_space:
    cmp qword [r10 + r11], 0
    jne .split_malloc
    jmp .new_malloc

    .protect:
        mov r10, qword [rel malloc_base]
        .loop_protect:
            cmp r10, 0
            je .bye
            mov r8, qword [r10]
            mov rax, 10
            mov rdi, r10
            mov rsi, 4096
            mov rdx, 1
            syscall
            cmp rax, 0
            jl .malloc_error2
            mov r10, r8
            jmp .loop_protect
    .bye:
    pop rax
    ret

    .init_malloc_page:
        mov rax, 9
        mov rdi, 0
        mov rsi, 4096
        mov rdx, 3
        mov r10, 34
        mov r8, -1
        mov r9, 0
        syscall
        cmp rax, 0
        jl .malloc_error2

        mov qword [rel malloc_base], rax
        mov qword [rax], 0
        mov qword [rax + 8], 13
        mov qword [rax + 16], 0
        mov qword [rax + 24], 0
        mov byte [rax + 32], 0

        jmp .alloc

    .create_malloc_page:
        push r8
        push r10
        mov rax, 9
        mov rdi, 0
        mov rsi, 4096
        mov rdx, 3
        mov r10, 34
        mov r8, -1
        mov r9, 0
        syscall
        pop r10
        pop r8
        cmp rax, 0
        jl .malloc_error

        mov qword [r10], rax
        mov r10, rax
        mov qword [r10], 0
        mov qword [r10 + 8], 13
        mov qword [r10 + 16], 0
        mov qword [r10 + 24], 0
        mov byte [r10 + 32], 0

        mov r11, 16
        jmp .new_malloc
    
    .go_next_malloc_page:
        cmp qword [r10], 0
        je .create_malloc_page
        mov r10, qword [r10]
        mov r11, -1
        jmp .find_space

    .split_malloc:
        mov byte [r10 + r11 + 16], 1
        mov rdi, qword [r10 + r11 + 8]
        push rdi
        cmp qword [r10 + r11], r8
        je .protect
        mov rsi, qword [r10 + r11]
        sub rsi, r8
        mov qword[r10 + r11], r8
        push rsi
        .find_last_space:
            add r11, 17
            cmp r11, 4096
            jge .go_next_malloc_page2
            cmp qword [r10 + r11], 0
            jne .find_last_space
        .continue_split_malloc:
        pop rsi
        pop rdi
        push rdi
        add rdi, r8
        mov qword [r10 + r11], rsi
        mov qword [r10 + r11 + 8], rdi
        mov byte [r10 + r11 + 16], 0
        jmp .protect

    .create_malloc_page2:
        push r8
        push r10
        mov rax, 9
        mov rdi, 0
        mov rsi, 4096
        mov rdx, 3
        mov r10, 34
        mov r8, -1
        mov r9, 0
        syscall
        pop r10
        pop r8
        cmp rax, 0
        jl .malloc_error3

        mov qword [r10], rax
        mov r10, rax
        mov qword [r10], 0
        mov qword [r10 + 8], 13
        mov qword [r10 + 16], 0
        mov qword [r10 + 24], 0
        mov byte [r10 + 32], 0

        mov r11, 16
        jmp .continue_split_malloc
    
    .go_next_malloc_page2:
        cmp qword [r10], 0
        je .create_malloc_page2
        mov r10, qword [r10]
        mov r11, -1
        jmp .continue_split_malloc

    .new_malloc:
        push r8
        push r10
        push r11

        mov rax, 9
        mov rdi, 0
        mov rsi, r8
        mov rdx, 3
        mov r10, 34
        mov r8, -1
        mov r9, 0
        syscall

        mov r9, rax
        pop r11
        pop r10
        pop r8
        cmp rax, 0
        jl .malloc_error

        mov rax, r8
        xor rdx, rdx
        mov rbx, 4096
        div rbx
        sub rbx, rdx
        add rbx, r8

        mov qword [r10 + r11], rbx
        mov qword [r10 + r11 + 8], r9
        mov byte [r10 + r11 + 16], 0

        jmp .split_malloc

    .malloc_error:
        mov rax, 1
        mov rdi, 2
        lea rsi, [rel malloc_bug]
        mov rdx, 26
        syscall
        mov rax, 0
        ret
    
    .malloc_error2:
        pop rax
        jmp .malloc_error
    
    .malloc_error3:
        pop rax
        jmp .malloc_error2

AsmDalloc:
    cmp rdi, 0
    je .bye
    mov r10, qword [rel malloc_base]
    cmp r10, -1
    je .error_free
    push rdi
    .unprotect:
        mov rax, 10
        mov rdi, r10
        mov rsi, 4096
        mov rdx, 3
        syscall
        cmp rax, 0
        jl .bug_free2
        cmp qword [r10], 0
        je .dalloc
        mov r10, qword [r10]
        jmp .unprotect
        
    .dalloc:
    pop rdi

    mov r10, qword [rel malloc_base]
    mov r11, -1
    .find_malloc:
        add r11, 17
        cmp r11, 4096
        jge .go_next_malloc_page
        cmp qword [r10 + r11], 0
        je .error_free
        cmp qword [r10 + r11 + 8], rdi
        jne .find_malloc
    
    cmp byte [r10 + r11 + 16], 0
    je .error_free
    mov byte [r10 + r11 + 16], 0

    mov r8, r10
    add r8, r11
    mov r10, qword [rel malloc_base]
    mov r11, -1
    .find_free_prev:
        add r11, 17
        cmp r11, 4096
        jge .go_next_malloc_page_prev
        cmp qword [r10 + r11], 0
        je .leave_find_free_prev
        cmp byte [r10 + r11 + 16], 1
        je .find_free_prev
        mov r9, qword [r10 + r11 + 8]
        add r9, qword [r10 + r11]
        cmp qword [r8 + 8], r9
        jne .find_free_prev
        mov r9, qword [r8]
        add qword [r10 + r11], r9
        jmp .swap_prev

         .go_next_malloc_page_prev:
            cmp qword [r10], 0
            je .leave_find_free_prev
            mov r10, qword [r10]
            mov r11, -1
            jmp .find_free_prev

    .leave_find_free_prev:

    mov r10, qword [rel malloc_base]
    mov r11, -1
    mov r9, qword [r8 + 8]
    add r9, qword [r8]
    .find_free_next:
        add r11, 17
        cmp r11, 4096
        jge .go_next_malloc_page_next
        cmp qword [r10 + r11], 0
        je .leave_find_free_next
        cmp byte [r10 + r11 + 16], 1
        je .find_free_next
        cmp qword [r10 + r11 + 8], r9
        jne .find_free_next
        mov r9, qword [r10 + r11]
        add qword [r8], r9
        jmp .swap_next

         .go_next_malloc_page_next:
            cmp qword [r10], 0
            je .leave_find_free_next
            mov r10, qword [r10]
            mov r11, -1
            jmp .find_free_next

    .leave_find_free_next:

    .protect:
        mov r10, qword [rel malloc_base]
        .loop_protect:
            cmp r10, 0
            je .bye
            mov r8, qword [r10]
            mov rax, 10
            mov rdi, r10
            mov rsi, 4096
            mov rdx, 1
            syscall
            cmp rax, 0
            jl .bug_free
            mov r10, r8
            jmp .loop_protect

    .bye:
    ret

    .go_next_malloc_page:
        cmp qword [r10], 0
        je .error_free
        mov r10, qword [r10]
        mov r11, -1
        jmp .find_malloc

    .swap_prev:
        mov r9, r10
        add r9, r11
        push r9
        mov r10, qword [rel malloc_base]
        mov r11, -1
        mov r9, 0
        .find_last_prev:
            add r11, 17
            cmp r11, 4096
            jge .go_next_malloc_page_last_prev
            cmp qword [r10 + r11], 0
            je .leave_find_last_prev
            mov r9, r10
            add r9, r11
            jmp .find_last_prev
        .leave_find_last_prev:
        mov r10, r9
        pop r9
        mov rdx, qword [r10 + 8]
        cmp qword [r9 + 8], rdx
        je .prev_is_last
        mov rdx, qword [r10]
        mov qword [r8], rdx
        mov rdx, qword [r10 + 8]
        mov qword [r8 + 8], rdx
        mov dl, byte [r10 + 16]
        mov byte [r8 + 16], dl
        mov qword [r10], 0
        mov qword [r10 + 8], 0
        mov byte [r10 + 16], 0
        mov r8, r9
        jmp .leave_find_free_prev

        .go_next_malloc_page_last_prev:
            cmp qword [r10], 0
            je .leave_find_last_prev
            mov r10, qword [r10]
            mov r11, -1
            jmp .find_last_prev

        .prev_is_last:
            mov rdx, qword [r10]
            mov qword [r8], rdx
            mov rdx, qword [r10 + 8]
            mov qword [r8 + 8], rdx
            mov dl, byte [r10 + 16]
            mov byte [r8 + 16], dl
            mov qword [r10], 0
            mov qword [r10 + 8], 0
            mov byte [r10 + 16], 0
            jmp .leave_find_free_prev
        
    .swap_next:
        mov r9, r10
        add r9, r11
        push r9
        mov r10, qword [rel malloc_base]
        mov r11, -1
        mov r9, 0
        .find_last_next:
            add r11, 17
            cmp r11, 4096
            jge .go_next_malloc_page_last_next
            cmp qword [r10 + r11], 0
            je .leave_find_last_next
            mov r9, r10
            add r9, r11
            jmp .find_last_next
        .leave_find_last_next:
        mov r10, r9
        pop r9
        mov rdx, qword [r10]
        mov qword [r9], rdx
        mov rdx, qword [r10 + 8]
        mov qword [r9 + 8], rdx
        mov dl, byte [r10 + 16]
        mov byte [r9 + 16], dl
        mov qword [r10], 0
        mov qword [r10 + 8], 0
        mov byte [r10 + 16], 0
        jmp .leave_find_free_next

        .go_next_malloc_page_last_next:
            cmp qword [r10], 0
            je .leave_find_last_next
            mov r10, qword [r10]
            mov r11, -1
            jmp .find_last_next

    .error_free:
        mov rax, 1
        mov rdi, 2
        lea rsi, [rel free_error]
        mov rdx, 24
        syscall
        mov rax, 39
        syscall
        mov rdi, rax
        mov rsi, 6
        mov rax, 62
        syscall
        ret
    
    .bug_free:
        mov rax, 1
        mov rdi, 2
        lea rsi, [rel free_bug]
        mov rdx, 26
        syscall
        mov rax, 39
        syscall
        mov rdi, rax
        mov rsi, 6
        mov rax, 62
        syscall
        ret

    .bug_free2:
        pop rax
        jmp .bug_free

AsmCalloc:
    push rdi
    push rsi
    call AsmAlloc
    pop rsi
    pop rdi
    xor rcx, rcx
    .loop_calloc:
        mov byte [rax + rcx], sil
        inc rcx
        cmp rcx, rdi
        jne .loop_calloc
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

AsmShowMemory:
    CALL_ AsmPutchar, 'g'
    CALL_ AsmPutchar, 'o'
    CALL_ AsmPutchar, 10
    mov r10, qword [rel malloc_base]
    cmp r10, -1
    je .bye
    .unprotect:
        mov rax, 10
        mov rdi, r10
        mov rsi, 4096
        mov rdx, 3
        syscall
        cmp rax, 0
        jl .bye
        cmp qword [r10], 0
        je .alloc
        mov r10, qword [r10]
        jmp .unprotect
    .alloc:

    mov r10, qword [rel malloc_base]
    mov r11, -1
    .find_space:
        add r11, 17
        cmp r11, 4096
        jge .go_next_malloc_page
        cmp qword[r10 + r11], 0
        je .continue_find_space
        xor rdi, rdi
        mov rdi, qword[r10 + r11]
        CALL_ AsmPutchar, 's'
        CALL_ AsmPutchar, ':'
        CALL_ AsmPutnbr, rdi
        CALL_ AsmPutchar, 32
        xor rdi, rdi
        mov rdi, qword[r10 + r11 + 8]
        CALL_ AsmPutchar, 'a'
        CALL_ AsmPutchar, ':'
        CALL_ AsmPutnbr, rdi
        CALL_ AsmPutchar, 32
        xor rdi, rdi
        movzx rdi, byte[r10 + r11 + 16]
        CALL_ AsmPutchar, 'e'
        CALL_ AsmPutchar, ':'
        CALL_ AsmPutnbr, rdi
        CALL_ AsmPutchar, 10
        jmp .find_space
    .continue_find_space:

    .protect:
        mov r10, qword [rel malloc_base]
        .loop_protect:
            cmp r10, 0
            je .bye
            mov r8, qword [r10]
            mov rax, 10
            mov rdi, r10
            mov rsi, 4096
            mov rdx, 1
            syscall
            cmp rax, 0
            jl .bye
            mov r10, r8
            jmp .loop_protect
    .bye:
    ret

    .go_next_malloc_page:
        cmp qword [r10], 0
        je .bye
        CALL_ AsmPutchar, 'n'
        CALL_ AsmPutchar, 'p'
        CALL_ AsmPutchar, 10
        mov r10, qword [r10]
        mov r11, -1
        jmp .find_space
    