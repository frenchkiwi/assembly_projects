section .data

section .text
    global AsmClearMemory
    %include "AsmLibrary.inc"

AsmClearMemory:
    ret