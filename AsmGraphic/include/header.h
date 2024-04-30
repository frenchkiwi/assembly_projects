/*
** EPITECH PROJECT, 2023
** Library
** File description:
** header.h
*/

#ifndef BASIC_
    #define BASIC_

    #include "AsmGraphic.h"

typedef struct global_s {
    aLink *link;
    aWindow *window;
    int window_close;
    aEvent event;
    aRectangle *rect;
    aText *text;
    struct timespec *ts;
    long timer_base;
    long timer_diff;
} global_t;

#endif
