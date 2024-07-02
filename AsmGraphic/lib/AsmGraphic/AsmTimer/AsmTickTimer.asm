section .data

section .text
    global AsmTickTimer
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmTickTimer:
    cmp rdi, 0
    je .bye_error0

    push r12
    mov r12, rdi

    sub rsp, 32
    mov rax, 228
    mov rdi, 0
    lea rsi, [rsp]
    syscall
    cmp rax, 0
    jl .bye_error

    mov rax, qword[rsp] ; get sec
    mov rbx, 1000000000
    mul rbx ; convert into sec
    mov rbx, qword[rsp + 8] ; get nanosec
    add rax, rbx ; add nanosec
    sub rax, qword[r12 + 8] ; get the delay between frame

    mov r8, rax
    mov rax, qword[r12] ; get sec

    xor r9, r9
    sub rax, r8 ; interval wanted - delay act
    cmp rax, 0
    jge .to_early

    mov r9, 1
    mov rax, 228
    mov rdi, 0
    lea rsi, [rsp]
    syscall

    mov rax, qword[rsp] ; get sec
    mov rbx, 1000000000
    mul rbx ; convert into sec
    mov rbx, qword[rsp + 8] ; get nanosec
    add rax, rbx ; add nanosec
    mov qword[r12 + 8], rax ; save the act time for next display

    .to_early:
    add rsp, 32
    pop r12
    mov rax, r9
    ret

    .bye_error:
        pop r12
    .bye_error0:
        mov rax, -1
        ret