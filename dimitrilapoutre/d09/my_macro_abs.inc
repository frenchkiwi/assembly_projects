%ifndef MACRO_ABS_
    %define MACRO_ABS_
    %macro ABS 1
        cmp %1, 0
        jge bye_ABS
        neg %1
        bye_ABS:
    %endmacro
%endif
