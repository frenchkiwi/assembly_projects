section .data
section .text
    global _start

count_valid_queens_placements:
    xor rax, rax
    cmp rdx, 1
    sete al
    jle .bye_error

    push rsp
    mov rbp, rsp

    sub rsp, rdx

    xor r9, r9; index

    xor rcx, rcx
    .loop:
        xor r8, r8
        .wanna_break:
            cmp r8, r9
            je .bye_wanna_break
            xor r10, r10
            mov r10b, byte[rsp + r8]
            cmp r10, rcx
            je .shift
            xor r10, r10
            mov r10b, byte[rsp + r8]
            sub r10, r8
            mov r11, rcx
            sub r11, r9
            cmp r10, r11
            je .shift
            xor r10, r10
            mov r10b, byte[rsp + r8]
            add r10, r8
            mov r11, rcx
            add r11, r9
            cmp r10, r11
            je .shift
            inc r8
            jmp .wanna_break
        .bye_wanna_break:
        inc r9
        cmp r9, rdx
        je .soluce_find
        mov byte[rsp + r9 - 1], cl
        xor rcx, rcx
        jmp .loop
        .soluce_find:
        dec r9
        inc rax
        mov rcx, rdx
        dec rcx
        .shift:
            inc rcx
            cmp rcx, rdx
            jne .loop
            cmp r9, 0
            je .bye
            dec r9
            xor rcx, rcx
            mov cl, byte[rsp + r9]
            jmp .shift

    .bye:
    mov rsp, rbp
    pop rsp
    
    .bye_error:
    ret

_start:
    mov rdx, 8
    call count_valid_queens_placements
    mov rdi, rax
    mov rax, 60
    syscall

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
