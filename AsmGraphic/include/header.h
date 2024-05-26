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
    aEvent event;
    aRectangle *rect;
    aText *text;
} global_t;

#endif
