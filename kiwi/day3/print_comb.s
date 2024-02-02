.global _start
.intel_syntax noprefix

.data
    i: .long '0'
    j: .long '0'
    k: .long '0'
    next: .asciz ", "

.text
    _start:
        jmp loop_i
        jmp end

    loop_i:
        mov r8d, [i]
        inc r8d
        mov [j], r8d
        loop_j:
            mov r8d, [j]
            add r8d, 1
            mov [k], r8d
            loop_k:
                call write_nb
                mov r8d, [k]
                add r8d, 1
                mov [k], r8d
                call check_end
                call write_next
                cmp r8d, '9'
                jle loop_k
            mov r8d, [j]
            add r8d, 1
            mov [j], r8d
            mov r9d, 0
            mov [k], r9d
            cmp r8d, '8'
            jle loop_j
        mov r8d, [i]
        add r8d, 1
        mov [i], r8d
        mov r9d, 0
        mov [j], r9d
        cmp r8d, '7'
        jle loop_i
        

    check_end:
        mov r9d, [i]
        cmp r9d, '7'
        je end
        ret

    write_next:
        lea rsi, [next]
        mov rax, 1
        mov rdi, 1
        mov rdx, 2
        syscall
        
        ret

    write_nb:
        mov rax, 1
        mov rdi, 1
        mov rdx, 1
        lea rsi, [i]
        syscall
        lea rsi, [j]
        syscall
        lea rsi, [k]
        syscall

        ret

    end:
        mov rax, 60
        mov rdi, 0
        syscall
