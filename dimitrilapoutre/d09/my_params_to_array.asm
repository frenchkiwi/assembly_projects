section .bss
    struct info_param
        .length resd 1
        .str resq 1
        .copy resq 1
        .word_array resq 1
    endstruct
section .text
    extern my_putstr
    global _start

my_params_to_array:
    mov rdx, 2 ; set compteur de loop a 2 pour standard stack + call function
    loop_argc_pta: ; loop for get argc
        mov rdi, 0 ; set rdi to 0 for see if there is param
        mov rdi, [rsp + 8 * rdx] ; copy current param
        cmp rdi, 0 ; check if copy work
        je bye_loop_argc_pta ;leave if copy failed
        inc rdx ; increase to next param
        jmp loop_argc_pta ; go loop again
    bye_loop_argc_pta: ;label bye
    mov rax, 12 ; ready to call brk
    mov rdi, 0 ; make failed brk for get actual heap
    syscall ; call brk
    push rax ; save the first malloc ptr
    lea rdi, [8 + rax + rdx * 8] ; malloc to len + 1 8octet
    mov rax, 12 ; ready to call brk
    syscall ; call brk
    pop rax ; go back to first malloc ptr

    ret

_start:
    call my_params_to_array
    jmp _exit

_exit:
    mov rdi, rdx
    mov rax, 60
    syscall
