%include "my_macro.asm"

section .data
    usage_msg db "Usage: grep [OPTION]... PATTERNS [FILE]...", 10, "Try 'grep --help' for more information.", 10, 0

section .bss
    buffer resb 30000

section .text
    extern my_puterror
    extern my_putnbr
    global _start

_start:
    mov r9, 0

    pop r10 ; get ac
    cmp r10, 1 ; check if usage
    je grep_usage ; go to usage if yes
    cmp r10, 2 ; check if its a cat void
    je grep_void ; go to cat void if yes

    pop rdi
    jmp _exit

grep_usage:
    CALL_ my_puterror, usage_msg
    mov r9, 2
    jmp _exit

grep_void:
    .loop:
        mov r10, 0
        .loop2:
            mov rax, 0
            mov rdi, 0
            mov rsi, buffer
            mov rdx, 29999
            syscall ; read the stdin

            cmp rax, 0
            je _exit
            cmp byte [-1 + buffer + rax], 10
            jne .again ; check if exit

        mov rdx, rax
        mov rax, 1
        mov rdi, 1
        mov rsi, 
        syscall ; print the buffer
        jmp .loop ; go again forever

    .again:

        jmp .loop2
_exit:
    mov rax, 60
    mov rdi, r9
    syscall
