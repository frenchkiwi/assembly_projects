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
        case aEventRequestError:
            my_putstr("error: ");
            my_putnbr(KEYCODE(event));
            my_putchar('\n');
            exit(0);
        case aEventReplyError:
            my_putstr("reply in event\n");
            exit(0);
        case aEventKeyPressed:
            my_putstr("key_pressed: ");
            my_putnbr(KEYCODE(event));
            my_putchar('\n');
            aBell(link, 40);
            break;
        case aEventMouseButtonPressed:
            my_putstr("button_pressed\n");
            break;
        case aEventExposure:
            aDisplayWindow(base->link, base->window);
            break;
        case aEventWindowMapped:
            my_putstr("window mapped successfully\n");
            break;
        case aEventWindowCreate:
            my_putstr("create window\n");
            break;
        case aEventWindowModified:
            aWindowUpdate(link, window, &event);
            if (aIsWindowResizing(window))
                my_putstr("window resized\n");
            if (aIsWindowMoving(window))
                my_putstr("window moved\n");
            break;
        case aEventSpecial:
            if (aIsWindowClosing(link, window, &event))
                aCloseWindow(window);
            break;
        default:
            my_putstr("analize: ");
            my_putnbr(TYPE(event));
            my_putchar('\n');
    }
}

global_t *init(char **env)
{
    global_t *base = malloc(sizeof(global_t));

    base->link = aCreateLink(env);
    base->window = aCreateWindow(base->link, (short[2]){800, 600});
    base->rect = aCreateRectangle((aPosSize){50, 120, 700, 10}, (aColor){255, 255, 0});
    base->text = aCreateText("Raph est gay!", (aPos){100, 100}, (aColor){0, 200, 255});
    base->ts = malloc(sizeof(struct timespec));
    clock_gettime(CLOCK_REALTIME, base->ts);
    base->timer_base = base->ts->tv_sec * 1000000000 + base->ts->tv_nsec;
    return base;
}

int main(int ac, char **av, char **env)
{
    global_t *base = init(env);
    
    aOpenFont(base->link, "fixed");
    aMapWindow(base->link, base->window);
    // add
    // error case for mapwindow avec un get reply pour le message de mapping
    display(base->link, base->window, base->rect, base->text);
    while (aIsWindowOpen(base->window)) {
        while (aPollEvent(base->link, &base->event))
            analize_event(base->link, base->window, base->event, base);
        clock_gettime(CLOCK_REALTIME, base->ts);
        base->timer_diff = base->ts->tv_sec * 1000000000 + base->ts->tv_nsec;
        if (base->timer_diff - base->timer_base
        >= 1000000000 / aGetWindowFps(base->window)) {
            // printf("%.0f fps\n", 1000000000 / (double)(base->timer_diff - base->timer_base));
            base->timer_base = base->timer_diff;
            update(base->link, base->window);
            display(base->link, base->window, base->rect, base->text);
        }
    }
    aDestroyText(base->text);
    aDestroyRectangle(base->rect);
    aDestroyWindow(base->link, base->window);
    aCloseLink(base->link);
    free(base->ts);
    free(base);
    show_malloc();
    return 0;
}
