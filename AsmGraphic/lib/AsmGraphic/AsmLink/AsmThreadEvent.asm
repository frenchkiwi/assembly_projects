section .data
    event_error db "Request contain an error", 0

section .text
    global AsmThreadEvent
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmThreadEvent:
    ; r8 store the event
    ; r9 store the thread_info
    ; r10 store link
    mov r10, r12
    mov r9, r12
    add r9, 12
    CALL_ AsmAlloc, 8
    mov r13, rax ; alloc the poll struct
    .loop:
        cmp byte[r9 + 1], 1
        je .bye

        mov r11d, dword[r10]
        mov dword[r13], r11d
        mov dword[r13 + 4], 1

        mov rax, 7
        lea rdi, [r13]
        mov rsi, 1
        mov rdx, 0
        syscall
        
        cmp word[r13 + 6], 8
        je .exit

        cmp word[r13 + 6], 16
        je .exit

        cmp rax, 0
        je .loop

        CALL_ AsmCalloc, 40, 0
        mov r8, rax ; alloc the event
        mov rax, 0 ; code for read
        xor rdi, rdi
        mov edi, dword[r10] ; read fd socket
        lea rsi, [r8 + 8] ; link the event anwser space
        mov rdx, 32 ; read a basic
        syscall

        cmp byte[r8 + 8], 0
        je .error_detect
        cmp byte[r8 + 8], 1
        jne .add_to_queue
        cmp dword[r8 + 12], 0
        je .add_to_queue ; if no more data add the event to queue

        xor rax, rax
        mov eax, dword[r8 + 12] ; get the extra data length
        mov rbx, 4
        mul rbx ; extra data is each 4byte
        push rax ; save the length of extra data
        add rax, 40 ; set the size of the new event

        CALL_ AsmCalloc, rax, 0; alloc the right one event

        mov r11, qword[r8 + 8]
        mov qword[rax + 8], r11
        mov r11, qword[r8 + 16]
        mov qword[rax + 16], r11
        mov r11, qword[r8 + 24]
        mov qword[rax + 24], r11
        mov r11, qword[r8 + 32]
        mov qword[rax + 32], r11 ; copy the data of old event into new event

        xchg rax, r8 ; swap value for free
        CALL_ AsmDalloc, rax ; free the old event

        mov rax, 0 ; code for read
        xor rdi, rdi
        mov edi, dword[r10] ; read fd socket
        lea rsi, [r8 + 40] ; link the event anwser space
        pop rdx ; get back the extra data length
        syscall

        .add_to_queue:
        CALL_ AsmLock, r9
        mov r11, qword[r9 + 14]
        mov qword[r8], r11
        mov qword[r9 + 14], r8
        CALL_ AsmUnlock, r9

        jmp .loop

    .bye:
        CALL_ AsmDalloc, r13
        mov rax, 60
        xor rdi, rdi
        mov byte[r9 + 1], 0
        syscall
    
    .error_detect:
        lea rax, [rel event_error]
        CALL_ AsmPutstr, rax
        CALL_ AsmPutchar, 32
        xor rax, rax
        mov al, byte[r8 + 9]
        CALL_ AsmPutlnbr, rax
        jmp .add_to_queue
    
    .exit:
        mov rax, 60
        xor rdi, rdi
        syscall