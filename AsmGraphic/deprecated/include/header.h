/*
** EPITECH PROJECT, 2023
** Library
** File description:
** header.h
*/

#ifndef BASIC_
    #define BASIC_

    #include "AsmGraphic.h"

typedef struct arg_update_s {
    aLink *link;
    aWindow *window;
} arg_update_t;

typedef struct arg_display_s {
    aLink *link;
    aWindow *window;
    aRectangle *rect;
    aText *text;
} arg_display_t;

typedef struct global_s {
    aLink *link;
    aWindow *window;
    aEvent event;
    aRectangle *rect;
    aText *text;
    arg_update_t arg_update;
    arg_display_t arg_display;
} global_t;

#endif
