/*
** EPITECH PROJECT, 2023
** assembly_projects
** File description:
** AsmLib.h
*/

#ifndef AsmGraphic_
    #define AsmGraphic_

    #include "AsmLibrary.h"

#define AsmEventRequestError 0
#define AsmEventReplyError 1
#define AsmEventKeyPressed 2
#define AsmEventKeyRelease 3
#define AsmEventMouseButtonPressed 4
#define AsmEventMouseButtonRelease 5
#define AsmEventExposure 12
#define AsmEventWindowMapped 19
#define AsmEventWindowCreate 21
#define AsmEventWindowModified 22
#define AsmEventSpecial 33

#define AsmTYPE(event) (unsigned char)event.data[0] % 128
#define AsmKEYCODE(event) (unsigned char)event.data[1]
#define AsmBUTTON(event) (unsigned char)event.data[1]
#define AsmCLIENT_WINDOW(event) (unsigned char)event.data[4] | (unsigned char)event.data[5] << 8 | (unsigned char)event.data[6] << 16 | (unsigned char)event.data[7] << 24
#define AsmCLIENT_ATOM(event) (unsigned char)event.data[8] | (unsigned char)event.data[9] << 8 | (unsigned char)event.data[10] << 16 | (unsigned char)event.data[11] << 24
#define AsmCONFIGURE_EVENT(event) (unsigned char)event.data[4] | (unsigned char)event.data[5] << 8 | (unsigned char)event.data[6] << 16 | (unsigned char)event.data[7] << 24

#define AsmPURPLE (AsmColor){0, 200, 0, 255}

//link: +0 4byte fd socket | +4 8byte thread_info | +12 8byte header | +20 request body
// thread_info: +0 1byte futex | +1 1byte conditionnal variable | +2 4byte thread id | +6 8byte thread_stack | +14 8byte event_queue
// event_queue: +0 8byte next_event | +8 32byte event_body
typedef struct AsmLink AsmLink;

// +0 4byte window_id | +4 4byte pixmap_id | +8 8byte link_fd | +16 4byte window_pos | +20 4byte window_size | +24 1byte window_depth | +25 1byte window_event (1 == move | 2 == resize) | +26 4byte window_gc | +30 4byte color
typedef struct AsmWindow AsmWindow;

// +0 4byte font_id | +4 8byte link
typedef struct AsmFont AsmFont;

// +0 8byte string of 255 char max | +8 8byte link | +16 4byte gc_id | +20 4byte pos | +24 4byte foreground color
typedef struct AsmText AsmText;

// +0 4byte pos | +4 4byte size | +8 8byte link | +16 4byte gc_id | +20 4byte color
typedef struct AsmRectangle AsmRectangle;

typedef struct {
    unsigned char unused;
    unsigned char red;
    unsigned char green;
    unsigned char blue;
} AsmColor;

typedef struct {
    short x;
    short y;
} AsmPos;

typedef struct {
    unsigned short width;
    unsigned short heigth;
} AsmSize;

typedef struct {
    short x;
    short y;
    unsigned short width;
    unsigned short height;
} AsmPosSize;

typedef struct {
    char data[32];
} AsmEvent;

typedef struct AsmTimer AsmTimer;

// Resources Gestion

// // AsmLink

AsmLink *AsmCreateLink(char **env);

char AsmPollEvent(AsmEvent *event, AsmWindow *window);

char AsmCloseLink(AsmLink *link);

// // AsmWindow

AsmWindow *AsmCreateWindow(AsmLink *link, AsmSize size, char *name);

char AsmOpenWindow(AsmWindow *window);

char AsmIsOpenWindow(AsmWindow *window);

AsmPos AsmPositionWindow(AsmWindow *window);

AsmSize AsmSizeWindow(AsmWindow *window);

char AsmClearWindow(AsmWindow *window, AsmColor color);

char AsmDisplayWindow(AsmWindow *window);

char AsmRenameWindow(AsmWindow *window, char *name);

char AsmCloseWindow(AsmWindow *window);

char AsmDestroyWindow(AsmWindow *window);

// // AsmText

AsmFont *AsmCreateFont(AsmLink *link, char *font);

char AsmDestroyFont(AsmFont *font);

AsmText *AsmCreateText(AsmLink *link, char *string, AsmFont *font, AsmPos pos);

char AsmDrawText(AsmWindow *window, AsmText *text);

char AsmDestroyText(AsmText *text);

// // AsmRectangle

AsmRectangle *AsmCreateRectangle(AsmLink *link, AsmPosSize dimension, AsmColor color);

char AsmDrawRectangle(AsmWindow *window, AsmRectangle *rectangle);

char AsmDestroyRectangle(AsmRectangle *rectangle);

// // AsmTask

AsmTimer *AsmInitTimer(double delay);

char AsmTickTimer(AsmTimer *timer);

char AsmDestroyTimer(AsmTimer *timer);

// // Fun

char AsmBell(AsmLink *link, char volume);

#endif