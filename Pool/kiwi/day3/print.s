.global _start
.intel_syntax noprefix

.text
    _start:
        mov rax, 1
        mov rdi, 1
        lea rsi, [test]
        mov rdx, 14
        syscall

        mov rax, 60
        mov rdi, 0
        syscall

test:
    .asciz "Baise ta mere\n"

