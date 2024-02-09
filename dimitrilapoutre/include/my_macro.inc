%ifndef MACRO_
    %define MACRO_
    %macro ABS 1
        cmp %1, 0
        jge %%bye_ABS
        neg %1
        %%bye_ABS:
    %endmacro

    %macro CALL_ 2-7
        push rdi ; -prologue-
        push rsi ;
        push rdx ;
        push rcx ;
        push r8 ;
        push r9 ;
        push r10 ;
        push r11 ; ----------
        mov rdi, %2 ; set 1st param
        %if %0 >= 3 ; check if there is 2nd param
            %rotate 1 ; move to 2nd param
            mov rsi, %2 ; set 2nd param
            %if %0 >= 4 ; check if there is 3rd param
                %rotate 1 ; move to 3rd param
                mov rdx, %2 ; set 3rd param
                %if %0 >= 5 ; check if there is 4th param
                    %rotate 1 ; move to 4th param
                    mov rcx, %2 ; set 4th param
                    %if %0 >= 6 ; check if there is 5th param
                        %rotate 1 ; move to 5th param
                        mov r8, %2 ; set 5th param
                        %if %0 == 7 ; check if there is 6th param
                            %rotate 1 ; move to 6th param
                            mov r9, %2 ; set 6th param
                        %endif
                    %endif
                %endif
            %endif
        %endif
        %rotate 2 ; move to function

        call %1 ; call function

        pop r11 ; -epilogue-
        pop r10 ;
        pop r9 ;
        pop r8 ;
        pop rcx ;
        pop rdx ;
        pop rsi ;
        pop rdi ; ----------
    %endmacro
%endif