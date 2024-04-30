section .data
    add_opp db "+", 0
    struct_add dq add_opp, my_add, 0
    sub_opp db "-", 0
    struct_sub dq sub_opp, my_sub, 0
    mul_opp db "*", 0
    struct_mul dq mul_opp, my_mul, 0
    div_opp db "/", 0
    struct_div dq div_opp, my_div, 0
    mod_opp db "%", 0
    struct_mod dq mod_opp, my_mod, 0
    usage_opp db "", 0
    struct_usage dq usage_opp, my_usage, 0
    OPERATOR_FUNCS dq struct_add, struct_sub, struct_mul, struct_div, struct_mod, struct_usage, 0
