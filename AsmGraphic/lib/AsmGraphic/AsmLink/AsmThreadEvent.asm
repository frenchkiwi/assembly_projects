section .data
    event_error db "Request contain an error", 0

section .text
    global AsmThreadEvent
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmThreadEvent:
    sub rsp, 8
    .loop:
        cmp byte[LINK_THREAD_VAR], 1
        je .bye

        mov r11, qword[LINK_SOCKET]
        mov dword[rsp], r11d
        mov dword[rsp + 4], 1

        mov rax, 7
        lea rdi, [rsp]
        mov rsi, 1
        mov rdx, 0
        syscall
        
        cmp word[rsp + 6], 8
        je .exit

        cmp word[rsp + 6], 16
        je .exit

        cmp rax, 0
        je .loop

        mov rdi, 40
        call AsmAlloc
        cmp rax, 0
        je .exit

        mov r13, rax ; alloc the event
        mov qword[r13], 0
        mov rax, 0 ; code for read
        mov rdi, qword[LINK_SOCKET] ; read fd socket
        lea rsi, [r13 + 8] ; link the event anwser space
        mov rdx, 32 ; read a basic
        syscall
        cmp rax, rdx
        jne .exit

        cmp byte[r13 + 8], 0
        je .error_detect
        cmp byte[r13 + 8], 1
        jne .add_to_queue
        cmp dword[r13 + 12], 0
        je .add_to_queue ; if no more data add the event to queue

        xor rax, rax
        mov eax, dword[r13 + 12] ; get the extra data length
        mov rbx, 4
        mul rbx ; extra data is each 4byte
        push rax ; save the length of extra data
        add rax, 40 ; set the size of the new event

        mov rdi, rax
        call AsmAlloc; alloc the right one event
        cmp rax, 0
        je .exit

        mov qword[rax], 0
        mov r8, qword[r13 + 8]
        mov qword[rax + 8], r8
        mov r8, qword[r13 + 16]
        mov qword[rax + 16], r8
        mov r8, qword[r13 + 24]
        mov qword[rax + 24], r8
        mov r8, qword[r13 + 32]
        mov qword[rax + 32], r8 ; copy the data of old event into new event

        xchg rax, r13 ; swap value for free
        mov rdi, rax
        call AsmDalloc ; free the old event

        mov rax, 0 ; code for read
        mov rdi, qword[LINK_SOCKET] ; read fd socket
        lea rsi, [r13 + 40] ; link the event anwser space
        pop rdx ; get back the extra data length
        syscall
        cmp rax, rdx
        jne .exit

        .add_to_queue:
        cmp byte[r13 + 8], 128
        jb .no_sub
        sub byte[r13 + 8], 128
        .no_sub:
        ; mov rdi, 'e'
        ; call AsmPutchar
        ; movzx rdi, byte[r13 + 8]
        ; call AsmPutlnbr
        lea rdi, [LINK_FUTEX]
        call AsmLock

        mov r8, r12
        add r8, 26
        .go_to_end:
            cmp qword[r8], 0
            je .quit_go_to_end
            mov r8, qword[r8]
            jmp .go_to_end
        .quit_go_to_end:
        mov qword[r8], r13

        lea rdi, [LINK_FUTEX]
        call AsmUnlock


        jmp .loop

    .bye:
        add rsp, 8
        mov rax, 60
        xor rdi, rdi
        mov byte[LINK_THREAD_VAR], 0
        syscall
    
    .error_detect:
        push r8
        lea rdi, [rel event_error]
        call AsmPutstr
        mov rdi, ' '
        call AsmPutchar
        pop r8
        movzx rdi, byte[r13 + 9]
        call AsmPutlnbr
        jmp .add_to_queue
    
    .exit:
        mov rax, 60
        xor rdi, rdi
        syscall