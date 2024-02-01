my_swap:
    xchg rdi, rsi
    ret

my_strlen:
    mov rax, -1
    loop_strlen:
        inc rax
        cmp byte [rdi + rax], 0
        jne loop_strlen
    ret

my_putstr:
    mov rsi, rdi
    mov rdx, -1
    loop_putstr:
        inc rdx
        cmp byte [rsi + rdx], 0
        jne loop_putstr
    mov rax, 1
    mov rdi, 1
    syscall
    ret

my_evil_str:
    mov rcx, -1
    loop_evil_str:
        inc rcx
        cmp byte [rdi + rcx], 0
        jne loop_evil_str
    
    mov rax, rcx
    xor rdx, rdx
    mov rbx, 2
    div rbx
    xchg rax, rcx

    mov rbx, 0
    loop_evil_str2:
        dec rax
        mov r8b, byte [rdi + rbx]
        mov r9b, byte [rdi + rax]
        mov byte [rdi + rbx], r9b
        mov byte [rdi + rax], r8b
        inc rbx
        loop loop_evil_str2
    mov rax, rdi
    ret

my_getnbr:
    mov r8, 1
    mov r9, 0
    mov rax, 0
    mov rcx, -1
    loop_getnbr:
        cmp rax, 2147483647
        jg zero
        cmp rax, -2147483648
        jl zero
        inc rcx
        cmp byte [rdi + rcx], 45
        je neg
        cmp byte [rdi + rcx], 43
        je pos
        cmp byte [rdi + rcx], 48
        jl bye
        cmp byte [rdi + rcx], 57
        jg bye
        
        mov r9, 1
        mov rdx, 10
        mul rdx

        movzx rbx, byte [rdi + rcx]
        sub bl, 48
        add rax, rbx
        jmp loop_getnbr

    zero:
        mov rax, 0
        ret

    pos:
        cmp r9, 0
        jne bye
        jmp loop_getnbr

    neg:
        cmp r9, 0
        jne bye
        neg r8
        jmp loop_getnbr

    bye:
        cmp r8, 1
        je bye2
        neg rax
        bye2:
            ret
