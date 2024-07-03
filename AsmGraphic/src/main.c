#include "AsmLibrary.h"
#include "AsmGraphic.h"

void analyze_event(AsmEvent event, AsmLink *link, AsmWindow *window)
{
    switch (AsmTYPE(event)) {
        case AsmEventKeyPressed:
            AsmPrint("Key pressed: %d\n", AsmKEYCODE(event));
            break;
        case AsmEventKeyRelease:
            AsmPrint("Key release: %d\n", AsmKEYCODE(event));
            break;
        case AsmEventMouseButtonPressed:
            AsmPrint("Button pressed: %d\n", AsmBUTTON(event));
            if (AsmBell(link, 99))
                AsmPutlstr("AsmBell error");
            break;
        case AsmEventMouseButtonRelease:
            AsmPrint("Button release: %d\n", AsmBUTTON(event));
            break;
        case AsmEventWindowModified:
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
            AsmPrint("Event unknow: %d\n", AsmTYPE(event));
    }
}

void update(AsmLink *link, AsmWindow *window, AsmRectangle *rectangle, AsmText *text, AsmCircle *circle)
{
    AsmPos pos = AsmGetPositionWindow(window);
    AsmSize size = AsmGetSizeWindow(window);

    AsmPrint("x: %d et y: %d\n", pos.x, pos.y);
    AsmPrint("width: %d et height: %d\n", size.width, size.heigth);
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
    AsmWindow *window = AsmCreateWindow(link, (AsmSize){800, 600}, "AsmGraphic Rework");
    if (!window)
        AsmPutlstr("AsmCreateWindow error");
    AsmEvent event;
    AsmFont *font = AsmCreateFont(link, "fixed");
    if (!font)
        AsmPutlstr("AsmCreateFont error");
    AsmText *text = AsmCreateText(link, "Bonjour", font, (AsmPos){50, 50});
    if (!text)
        AsmPutlstr("AsmCreateText error");
    AsmRectangle *rectangle = AsmCreateRectangle(link, (AsmPosSize){50, 70, 500, 5}, AsmPURPLE);
    if (!rectangle)
        AsmPutlstr("AsmCreateRectangle error");
    AsmCircle *circle = AsmCreateCircle(link, (AsmPosSize){300, 300, 200, 50}, (AsmAngle){0.0, 360.0}, AsmPURPLE);
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