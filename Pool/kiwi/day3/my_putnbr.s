.global my_putnbr
.intel_syntax noprefix

.data
    neg: .byte '-'
    value: .byte '0'

.text
    my_putnbr:
        mov r8, rdi
        cmp r8, 0
        jl negatif
        return_neg:
        push r8
        call putall
        ret
    
    negatif:
        mov rdi, 1
        mov rax, 1
        mov rdx, 1
        lea rsi, [neg]
        syscall
        neg r8
        jmp return_neg

    c_putall:
        mov rax, r8
        xor rdx, rdx
        mov rbx, 10
        div rbx
        push rax
        call putall
        jmp put_return

    putall:
        pop r9
        pop r8
        push r8
        push r9
        cmp r8, 9
        jg c_putall
        put_return:
        pop r9
        pop r8
        push r9
        mov rax, r8
        xor rdx, rdx
        mov rbx, 10
        div rbx
        add rdx, 48
        mov [value], rdx
        mov rdi, 1
        mov rax, 1
        mov rdx, 1
        lea rsi, [value]
        syscall
        ret
