/*
** EPITECH PROJECT, 2023
** Library
** File description:
** main.c
*/

#include "header.h"
#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

void display(aLink *link, aWindow *window, aRectangle *rect, aText *text)
{
    aClearWindow(link, window);
    aDrawRectangle(link, window, rect);
    aDrawText(link, window, text);
    aDisplayWindow(link, window);
}

void update(aLink *link, aWindow *window)
{
    aPos pos;
    aSize size;

    pos = aGetWindowPosition(window);
    size = aGetWindowSize(window);
}

void analize_event(aLink *link, aWindow *window, aEvent event, global_t *base)
{
    switch (TYPE(event) % 128) {
        case 0:
            putstr("error: ");
            putnbr(KEYCODE(event));
            putchar('\n');
            exit(0);
        case 1:
            putstr("reply in event\n");
            exit(0);
        case 2:
            putstr("key_pressed: ");
            putnbr(KEYCODE(event));
            putchar('\n');
            aBell(link, 40);
            break;
        case 4:
            putstr("button_pressed\n");
            break;
        case 12:
            aDisplayWindow(base->link, base->window);
            break;
        case 19:
            putstr("window mapped successfully\n");
            break;
        case 21:
            putstr("create window\n");
            break;
        case 22:
            aWindowUpdate(link, window, &event);
            break;
        case 33:
            base->window_close = aIsWindowClosing(link, window, &event);
            break;
        default:
            putstr("analize: ");
            putnbr(TYPE(event));
            putchar('\n');
    }
}

global_t *init(void)
{
    global_t *base = malloc(sizeof(global_t));

    base->link = aCreateLink();
    base->window = aCreateWindow(base->link, (short[2]){800, 600});
    base->window_close = 0;
    base->rect = aCreateRectangle((aPosSize){200, 120, 300, 300}, (aColor){255, 255, 0});
    base->text = aCreateText("Hello World!", (aPos){100, 100}, (aColor){0, 200, 255});
    base->ts = malloc(sizeof(struct timespec));
    clock_gettime(CLOCK_REALTIME, base->ts);
    base->timer_base = base->ts->tv_sec * 1000000000 + base->ts->tv_nsec;
    return base;
}

int main(void)
{
    global_t *base = init();
    
    aOpenFont(base->link, "fixed");
    aMapWindow(base->link, base->window);
    // add
    // error case for mapwindow avec un get reply pour le message de mapping
    display(base->link, base->window, base->rect, base->text);
    while (!base->window_close) {
        while (aPollEvent(base->link, &base->event))
            analize_event(base->link, base->window, base->event, base);
        clock_gettime(CLOCK_REALTIME, base->ts);
        base->timer_diff = base->ts->tv_sec * 1000000000 + base->ts->tv_nsec;
        if (base->timer_diff - base->timer_base
        >= 1000000000 / aGetWindowFps(base->window)) {
            printf("%.0f fps\n",
            1000000000 / (double)(base->timer_diff - base->timer_base));
            base->timer_base = base->timer_diff;
            update(base->link, base->window);
            display(base->link, base->window, base->rect, base->text);
        }
    }
    aDestroyText(base->text);
    aDestroyRectangle(base->rect);
    aCloseWindow(base->link, base->window);
    aCloseLink(base->link);
    free(base->ts);
    free(base);
    show_malloc();
    return 0;
}
