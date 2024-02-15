%include "my_macro.asm"

section .data
    base db "0123456789", 0
section .text
    extern my_putchar
    extern my_strlen
    extern my_strdup
    extern my_str_to_word_array
    extern my_putnbr_base
    extern my_putstr
    extern my_show_word_array
    global _start

my_params_to_array:
    mov rdx, 2 ; set compteur de loop a 2 pour standard stack + call function
    .loop_argc_pta: ; loop for get argc
        mov rdi, 0 ; set rdi to 0 for see if there is param
        mov rdi, [rsp + 8 * rdx] ; copy current param
        cmp rdi, 0 ; check if copy work
        je .bye_loop_argc_pta ;leave if copy failed
        inc rdx ; increase to next param
        jmp .loop_argc_pta ; go loop again
    .bye_loop_argc_pta: ;label bye
    sub rdx, 2
    mov rax, 12 ; ready to call brk
    mov rdi, 0 ; make failed brk for get actual heap
    syscall ; call brk
    push rax ; save the first malloc ptr
    lea rdi, [8 + rax + rdx * 8] ; malloc to (len + 1) 8octet (ptr)
    mov rax, 12 ; ready to call brk
    syscall ; call brk
    pop rax ; go back to first malloc ptr

    mov rsi, rdx ; save the nb of params
    mov qword [rax + rdx * 8], 0 ; set the NULL ptr for end the array
    .loop_alloc_struct: ; go allocate all the struct for fill the array
        dec rdx ; go to the next param
        push rax ; save the array ptr
        mov rax, 12 ; ready to call brk
        mov rdi, 0 ; make failed brk for get actual heap
        syscall ; call brk
        pop rdi ; go back to array ptr
        mov [rdi + rdx * 8], rax ; set the struct in the array
        push rdi ; repush the array ptr
        lea rdi, [rax + 28] ; malloc to the size of the struct (24octet: 1int and 3ptr)
        mov rax, 12 ; ready to call brk
        syscall ; call brk
        pop rax ; get back the array ptr
        cmp rdx, 0 ; check if we have alloc all the struct
        jne .loop_alloc_struct ; if yes go to the loop_alloc_struct
    mov rdx, rsi ; get back the rdx register

    .loop_add_value_to_struct: ; loop for fill the struct
        dec rdx ; decrease the counter for good position in index
        mov rdi, [16 + rsp + rdx * 8] ; get the value of param

        push rax ; save the array ptr
        call my_strlen; get .length
        mov rcx, rax
        pop rax ; get back the array ptr
        mov r8, [rax + rdx * 8] ; r8 is the actual struct node
        mov [r8], ecx ; set the length in the struct

        mov r8, [rax + rdx * 8] ; r8 is the actual struct node
        mov [4 + r8], rdi ; set the str in the struct

        push rdi
        push rax
        call my_strdup
        mov rcx, rax
        pop rax
        pop rdi
        mov r8, [rax + rdx * 8] ; r8 is the actual struct node
        mov [12 + r8], rcx ; set the str in the struct

        push rdi
        push rax
        push rdx
        call my_str_to_word_array
        mov rcx, rax
        pop rdx
        pop rax
        pop rdi
        mov r8, [rax + rdx * 8] ; r8 is the actual struct node
        mov [20 + r8], rcx ; set the str in the struct

        cmp rdx, 0 ; check if it's the end
        jne .loop_add_value_to_struct ; if no go again fill this struct
    ret ; bye

my_show_param_array:
    mov rcx, 0
    .loop:
        cmp qword [rdi + rcx * 8], 0
        je .bye
        mov r12, [rdi + rcx * 8]
        push rdi
        push rcx
        mov edi, [r12]
        mov rsi, base
        call my_putnbr_base
        mov rdi, 10
        call my_putchar
        mov rdi, [r12 + 4]
        call my_putstr
        mov rdi, 10
        call my_putchar
        mov rdi, [r12 + 12]
        call my_putstr
        mov rdi, 10
        call my_putchar
        mov rdi, [r12 + 20]
        call my_show_word_array
        pop rcx
        pop rdi
        inc rcx
        jmp .loop
    .bye:
    ret

_start:
    call my_params_to_array
    mov rdi, rax
    call my_show_param_array
    jmp _exit


_exit:
    mov rdi, 0
    mov rax, 60
    syscall
