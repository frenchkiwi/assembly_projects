/*
** EPITECH PROJECT, 2023
** Library
** File description:
** header.h
*/

#ifndef GRAPHIC_
    #define GRAPHIC_

    #include "AsmFunctions.h"

#define TYPE(event) (unsigned char)event.data[0]
#define KEYCODE(event) (unsigned char)event.data[1]
#define BUTTON(event) (unsigned char)event.data[1]
#define CLIENT_WINDOW(event) (unsigned char)event.data[4] | (unsigned char)event.data[5] << 8 | (unsigned char)event.data[6] << 16 | (unsigned char)event.data[7] << 24
#define CLIENT_ATOM(event) (unsigned char)event.data[8] | (unsigned char)event.data[9] << 8 | (unsigned char)event.data[10] << 16 | (unsigned char)event.data[11] << 24
#define CONFIGURE_EVENT(event) (unsigned char)event.data[4] | (unsigned char)event.data[5] << 8 | (unsigned char)event.data[6] << 16 | (unsigned char)event.data[7] << 24

#define aPURPLE (unsigned char[3]){200, 0, 255}

typedef struct AsmLink aLink;

typedef struct AsmWindow aWindow;
// typedef unsigned long aWindow;

typedef unsigned char aColor[3];

typedef unsigned char aFps;

typedef struct {
    short x;
    short y;
} aPos;

typedef struct {
    unsigned short width;
    unsigned short heigth;
} aSize;

typedef struct {
    short x;
    short y;
    unsigned short width;
    unsigned short height;
} aPosSize;

typedef struct {
    char data[32];
} aEvent;

typedef struct AsmText aText;

typedef struct AsmRectangle aRectangle;

// void aCreateContext(aLink *);


// Fonction Event

// // AsmEvent

int aPollEvent(aLink *link, aEvent *event);

// // AsmWindow

void aWindowUpdate(aLink *link, aWindow *window, aEvent *event);

int aIsWindowMoving(aLink *link, aWindow *window, aEvent *event);

int aIsWindowResizing(aLink *link, aWindow *window, aEvent *event);

int aIsWindowClosing(aLink *link, aWindow *window, aEvent *event);

aFps aGetWindowFps(aWindow *window);

aPos aGetWindowPosition(aWindow *window);

aSize aGetWindowSize(aWindow *window);

// Resources Gestion

// // AsmLink

aLink *aCreateLink(void);

int aCloseLink(aLink *link);

// // AsmWindow

aWindow *aCreateWindow(aLink *link, short size[2]);

void aMapWindow(aLink *link, aWindow *window);

void aClearWindow(aLink *link, aWindow *window);

void aDisplayWindow(aLink *link, aWindow *window);

void aCloseWindow(aLink *link, aWindow *window);

// // AsmFont

void aOpenFont(aLink *link, char *);

// // AsmClock

// // AsmText

aText *aCreateText(char *string, aPos pos, aColor color);

void aDrawText(aLink *link, aWindow *window, aText *text);

void aDestroyText(aText *text);

// // AsmRectangle

aRectangle *aCreateRectangle(aPosSize rect, aColor color);

void aDrawRectangle(aLink *link, aWindow *window, aRectangle *rect);

void aDestroyRectangle(aRectangle *rect);

// Miscellaneous

void aBell(aLink *link, char volume);

#endif
