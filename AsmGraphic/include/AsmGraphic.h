/*
** EPITECH PROJECT, 2023
** Library
** File description:
** header.h
*/

#ifndef GRAPHIC_
    #define GRAPHIC_

    #include "AsmFunctions.h"

#define aEventRequestError 0
#define aEventReplyError 1
#define aEventKeyPressed 2
#define aEventKeyRelease 3
#define aEventMouseButtonPressed 4
#define aEventMouseButtonRelease 5
#define aEventExposure 12
#define aEventWindowMapped 19
#define aEventWindowCreate 21
#define aEventWindowModified 22
#define aEventSpecial 33

#define TYPE(event) (unsigned char)event.data[0]
#define KEYCODE(event) (unsigned char)event.data[1]
#define BUTTON(event) (unsigned char)event.data[1]
#define CLIENT_WINDOW(event) (unsigned char)event.data[4] | (unsigned char)event.data[5] << 8 | (unsigned char)event.data[6] << 16 | (unsigned char)event.data[7] << 24
#define CLIENT_ATOM(event) (unsigned char)event.data[8] | (unsigned char)event.data[9] << 8 | (unsigned char)event.data[10] << 16 | (unsigned char)event.data[11] << 24
#define CONFIGURE_EVENT(event) (unsigned char)event.data[4] | (unsigned char)event.data[5] << 8 | (unsigned char)event.data[6] << 16 | (unsigned char)event.data[7] << 24

#define aPURPLE (unsigned char[3]){200, 0, 255}

//link: +0 4byte fd socket | +4 8byte thread_info | +12 8byte header | +20 request body
// thread_info: +0 1byte futex | +1 1byte conditionnal variable | +2 4byte thread id | +6 8byte thread_stack | +14 8byte event_queue
// event_queue: +0 8byte next_event | +8 32byte event_body
typedef struct AsmLink aLink;

// +0 4byte window_id | +4 4byte pixmap_id | +8 4byte window_pos | +12 4byte window_size | +16 1byte window_depth | +17 1byte window_fps | +18 1byte window_state | +19 1byte window_event (1 == move | 2 == resize)
typedef struct AsmWindow aWindow;

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

int aIsWindowMoving(aWindow *window);

int aIsWindowResizing(aWindow *window);

int aIsWindowClosing(aLink *link, aWindow *window, aEvent *event);

int aIsWindowOpen(aWindow *window);

aFps aSetWindowFps(aWindow *window, char fps);

aFps aGetWindowFps(aWindow *window);

aPos aGetWindowPosition(aWindow *window);

aSize aGetWindowSize(aWindow *window);

// Resources Gestion

// // AsmLink

aLink *aCreateLink(char **env);

int aCloseLink(aLink *link);

// // AsmWindow

aWindow *aCreateWindow(aLink *link, short size[2]);

void aMapWindow(aLink *link, aWindow *window);

void aClearWindow(aLink *link, aWindow *window);

void aDisplayWindow(aLink *link, aWindow *window);

void aCloseWindow(aWindow *window);

void aDestroyWindow(aLink *link, aWindow *window);

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
