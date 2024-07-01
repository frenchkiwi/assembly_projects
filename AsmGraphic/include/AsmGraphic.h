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

#define TYPE(event) (unsigned char)event.data[0]
#define KEYCODE(event) (unsigned char)event.data[1]
#define BUTTON(event) (unsigned char)event.data[1]
#define CLIENT_WINDOW(event) (unsigned char)event.data[4] | (unsigned char)event.data[5] << 8 | (unsigned char)event.data[6] << 16 | (unsigned char)event.data[7] << 24
#define CLIENT_ATOM(event) (unsigned char)event.data[8] | (unsigned char)event.data[9] << 8 | (unsigned char)event.data[10] << 16 | (unsigned char)event.data[11] << 24
#define CONFIGURE_EVENT(event) (unsigned char)event.data[4] | (unsigned char)event.data[5] << 8 | (unsigned char)event.data[6] << 16 | (unsigned char)event.data[7] << 24

#define PURPLE (unsigned char[3]){200, 0, 255}

#define AsmSecond(time) (long)((double)(time))
#define AsmNanoSecond(time) 

#define AsmSetTask(name, function_addr, arg_addr, delay) \
    do { \
        name.function = function_addr; \
        name.arg = arg_addr; \
        name.interval[0] = (long)((double)delay); \
        name.interval[1] = (long)((double)((double)(delay) - aSecond(delay)) * 1000000000); \
        name.last_time = 0; \
    } while (0)

//link: +0 4byte fd socket | +4 8byte thread_info | +12 8byte header | +20 request body
// thread_info: +0 1byte futex | +1 1byte conditionnal variable | +2 4byte thread id | +6 8byte thread_stack | +14 8byte event_queue
// event_queue: +0 8byte next_event | +8 32byte event_body
typedef struct AsmLink AsmLink;

// +0 4byte window_id | +4 4byte pixmap_id | +8 8byte link_fd | +16 4byte window_pos | +20 4byte window_size | +24 1byte window_depth | +25 1byte window_event (1 == move | 2 == resize)
typedef struct AsmWindow AsmWindow;

typedef unsigned char AsmColor[3];

typedef unsigned char AsmFps;

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

typedef struct {
    void (*function)(void *);
    void *arg;
    long interval[2];
    long last_time;
} AsmTask;

typedef struct AsmText AsmText;

typedef struct AsmRectangle AsmRectangle;

// Resources Gestion

// // AsmLink

AsmLink *AsmCreateLink(char **env);

char AsmCloseLink(AsmLink *link);

// // AsmWindow

AsmWindow *AsmCreateWindow(AsmLink *link, AsmSize size, char *name);

char AsmOpenWindow(AsmWindow *window);

char AsmRenameWindow(AsmWindow *window, char *name);

char AsmCloseWindow(AsmWindow *window);

char AsmDestroyWindow(AsmWindow *window);

#endif