section .data

section .text
    global AsmCloseWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmCloseWindow:
    mov byte[rdi + 18], 0
    ret