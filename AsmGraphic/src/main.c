#include "AsmLibrary.h"
#include "AsmGraphic.h"

void analyze_event(AsmEvent event, AsmLink *link, AsmWindow *window)
{
    switch (event.info.type) {
        case AsmEventKeyPressed:
            AsmPrint("Key pressed: %b\n", event.key.keycode);
            break;
        case AsmEventKeyRelease:
            AsmPrint("Key release: %b\n", event.key.keycode);
            break;
        case AsmEventMouseButtonPressed:
            AsmPrint("Button pressed: %b at x: %w, y: %w\n", event.mouse.button, event.mouse.pos_window.x, event.mouse.pos_window.y);
            if (AsmBell(link, 100))
                AsmPutlstr("AsmBell error");
            break;
        case AsmEventMouseMoved:
            AsmPrint("Mouse moved at x: %w, y: %w\n", event.mouse.pos_window.x, event.mouse.pos_window.y);
            break;
        case AsmEventMouseButtonRelease:
            AsmPrint("Button release: %b\n", event.mouse.button);
            break;
        case AsmEventGetFocus:
            AsmPutlstr("Window get focus");
            break;
        case AsmEventLostFocus:
            AsmPutlstr("Window lost focus");
            break;
        case AsmEventWindowModified:
            AsmPutlstr("Window modified");
            if (AsmHasMovedWindow(window))
                AsmPutlstr("Window moved");
            if (AsmHasResizedWindow(window))
                AsmPutlstr("Window resized");
            break;
        case AsmEventClose:
            if (AsmCloseWindow(window))
                AsmPutlstr("AsmCloseWindow error");
            break;
        default:
            AsmPrint("Event unknow: %d\n", event.info.type);
    }
}

void update(AsmLink *link, AsmWindow *window, AsmRectangle *rectangle, AsmText *text, AsmCircle *circle)
{
    AsmPos pos = AsmGetPositionWindow(window);
    AsmSize size = AsmGetSizeWindow(window);
    AsmColor rectangle_color = AsmGetColorRectangle(rectangle);
    AsmColor text_color = AsmGetColorText(text);
    AsmColor circle_color = AsmGetColorCircle(circle);

    AsmPrint("x: %w et y: %w\n", pos.x, pos.y);
    AsmPrint("width: %w et height: %w\n", size.width, size.heigth);
    AsmPrint("rectangle: red: %q, green: %q, blue: %q\n", rectangle_color.red, rectangle_color.green, rectangle_color.blue);
    AsmPrint("text: red: %q, green: %q, blue: %q\n", text_color.red, text_color.green, text_color.blue);
    AsmPrint("circle: red: %q, green: %q, blue: %q\n", circle_color.red, circle_color.green, circle_color.blue);
    return;
}

void display(AsmLink *link, AsmWindow *window, AsmRectangle *rectangle, AsmText *text, AsmCircle *circle)
{
    if (AsmClearWindow(window, (AsmColor){0, 0, 0, 0}))
        AsmPutlstr("AsmClearWindow error");
    if (AsmDrawRectangle(window, rectangle))
        AsmPutlstr("AsmDrawRectangle error");
    if (AsmDrawText(window, text))
        AsmPutlstr("AsmDrawText error");
    if (AsmDrawCircle(window, circle))
        AsmPutlstr("AsmDrawCircle error");
    if (AsmDisplayWindow(window))
        AsmPutlstr("AsmDisplayWindow error");
    return;
}

int main(int ac, char **av, char **envp)
{
    AsmLink *link = AsmCreateLink(envp);
    if (!link)
        AsmPutlstr("AsmCreateLink error");
    AsmWindow *window = AsmCreateWindow(link, (AsmSize){400, 300}, "AsmGraphic Rework");
    if (!window)
        AsmPutlstr("AsmCreateWindow error");
    AsmEvent event;
    AsmFont *font = AsmCreateFont(link, "fixed");
    if (!font)
        AsmPutlstr("AsmCreateFont error");
    AsmText *text = AsmCreateText(link, "Bonjour", font, (AsmPos){50, 50});
    if (!text)
        AsmPutlstr("AsmCreateText error");
    AsmRectangle *rectangle = AsmCreateRectangle(link, (AsmPosSize){50, 70, 1800, 5}, AsmPurple);
    if (!rectangle)
        AsmPutlstr("AsmCreateRectangle error");
    AsmCircle *circle = AsmCreateCircle(link, (AsmPosSize){300, 300, 50, 50}, (AsmAngle){0.0, 360.0}, AsmPurple);
    if (!circle)
        AsmPutlstr("AsmCreateCircle error");
    AsmTimer *updateT = AsmInitTimer(2.0);
    if (!updateT)
        AsmPutlstr("AsmInitTimer error");
    AsmTimer *displayT = AsmInitTimer(1 / 60.0);
    if (!displayT)
        AsmPutlstr("AsmInitTimer error");

    if (AsmOpenWindow(window))
        AsmPutlstr("AsmOpenWindow error");
    if (AsmSetPositionWindow(window, (AsmPos){0, 0}))
        AsmPutlstr("AsmSetPositionWindow error");
    if (AsmSetSizeWindow(window, (AsmSize){800, 600}))
        AsmPutlstr("AsmSetSizeWindow error");
    if (AsmSetColorRectangle(rectangle, AsmGreen))
        AsmPutlstr("AsmSetColorRectangle error");
    if (AsmSetColorCircle(circle, AsmWhite))
        AsmPutlstr("AsmSetColorCircle error");
    if (AsmSetColorText(text, AsmPurple))
        AsmPutlstr("AsmSetColorText error");
    while (AsmIsOpenWindow(window)) {
        while (AsmPollEvent(&event, window))
            analyze_event(event, link, window);
        if (AsmTickTimer(updateT))
            update(link, window, rectangle, text, circle);
        if (AsmTickTimer(displayT))
            display(link, window, rectangle, text, circle);
    }

    if (AsmDestroyTimer(displayT))
        AsmPutlstr("AsmDestroyTimer error");
    if (AsmDestroyTimer(updateT))
        AsmPutlstr("AsmDestroyTimer error");
    if (AsmDestroyCircle(circle))
        AsmPutlstr("AsmDestroyCircle error");
    if (AsmDestroyRectangle(rectangle))
        AsmPutlstr("AsmDestroyRectangle error");
    if (AsmDestroyText(text))
        AsmPutlstr("AsmDestroyText error");
    if (AsmDestroyFont(font))
        AsmPutlstr("AsmDestroyFont error");
    if (AsmDestroyWindow(window))
        AsmPutlstr("AsmDestoyWindow error");
    if (AsmCloseLink(link))
        AsmPutlstr("AsmCloseLink error");
    AsmShowMemory();
    return 0;
}