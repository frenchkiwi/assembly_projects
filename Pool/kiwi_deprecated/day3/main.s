.global _start
.intel_syntax noprefix

.text
    _start:
        mov r8d, 20
        call isneg

        mov rax, 60
        mov rdi, 0
        syscall
