section .data

section .text
    global AsmCloseWindow
    %include "AsmLibrary.inc"
    %include "AsmGraphic.inc"

AsmCloseWindow:
    ret