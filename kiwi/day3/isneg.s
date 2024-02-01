.global isneg
.intel_syntax noprefix

.data
    p_letter: .long 80
    n_letter: .long 78

.text
    isneg:
        mov rdi, 1
        mov rax, 1
        mov rdx, 1
        cmp r8d, 0
        jl negatif
        lea rsi, [p_letter]
        syscall
        ret
    
    negatif:
        lea rsi, [n_letter]
        syscall
        ret
