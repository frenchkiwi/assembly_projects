section .data
    len equ 3
    again db ", "

section .bss
    number resb len + 1

section .text
    global _start

write:
    mov rax, 1
    mov rdi, 1
    mov rsi, number
    mov rdx, len
    syscall
    ret

write_again:
    mov rax, 1
    mov rdi, 1
    mov rsi, again
    mov rdx, 2
    syscall
    ret

_start:
    mov rcx, 0
    loop_fs:
        mov r8b, cl
        add r8b, 48
        mov byte [number + rcx], r8b
        inc rcx
        cmp rcx, len
        jl loop_fs
    mov byte [number + len], 0
    jmp _loop

check_end:
    mov rcx, -1
    loop_end:
        inc rcx
        cmp rcx, len
        je _exit
        mov r8b, 58 - len
        add r8b, cl
        cmp byte [number + rcx], r8b
        je loop_end
    ret

up:
    mov rcx, len
    loop_up:
        dec rcx
        inc byte [number + rcx]
        mov r8b, 59 - len
        add r8b, cl
        cmp byte [number + rcx], r8b
        je loop_up
    help_up:
        mov r8b, [number + rcx]
        inc r8b
        inc rcx
        mov [number + rcx], r8b
        cmp rcx, len
        jne help_up
    mov byte [number + len], 0
    ret

_loop:
    call write
    call check_end
    call write_again
    call up
    jmp _loop

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
                
