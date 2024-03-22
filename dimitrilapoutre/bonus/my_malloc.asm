%include "my_macro.asm"

section .data
    malloc_base dq -1
    free_error db 'f', 'r', 'e', 'e', '(', ')', ':', ' ', 'i', 'n', 'v', 'a', 'l', 'i', 'd', ' ', 'p', 'o', 'i', 'n', 't', 'e', 'r', 10

section .text
    global _start
    extern my_putnbr
    extern my_putstr
    extern my_putchar
    extern my_compute_power_it
; next (8) empty (8) | size du malloc(8), adress du malloc(8), etat(1)
; r8 = size a malloc
; r9 = zone de malloc actuel
; r10 = page de malloc save actuel
; r11 = malloc save actuel
my_malloc:
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
        mov qword [r10 + r11 + 16], 0
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
        mov rax, 0
        ret

my_free:
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

_start:
    mov rdi, 4
    call my_malloc
    push rax
    mov rdi, rax
    call my_free
    pop rax
    mov rdi, rax
    call my_free
    jmp _exit

_exit:
    mov rdi, rax
    mov rax, 60
    syscall
