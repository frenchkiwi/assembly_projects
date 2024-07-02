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
        case AsmEventSpecial:
            if (AsmCloseWindow(window))
                AsmPutlstr("AsmCloseWindow error");
            break;
        default:
            AsmPrint("Event unknow: %d\n", AsmTYPE(event));
    }
}

void update(AsmLink *link, AsmWindow *window, AsmRectangle *rectangle, AsmText *text)
{
    AsmPos pos = AsmPositionWindow(window);
    AsmSize size = AsmSizeWindow(window);

    AsmPrint("x: %d et y: %d\n", pos.x, pos.y);
    AsmPrint("width: %d et height: %d\n", size.width, size.heigth);
    return;
}

void display(AsmLink *link, AsmWindow *window, AsmRectangle *rectangle, AsmText *text)
{
    if (AsmClearWindow(window, (AsmColor){0, 0, 0, 0}))
        AsmPutlstr("AsmClearWindow error");
    if (AsmDrawText(window, text))
        AsmPutlstr("AsmDrawText error");
    if (AsmDrawRectangle(window, rectangle))
        AsmPutlstr("AsmDrawRectangle error");
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
            update(link, window, rectangle, text);
        if (AsmTickTimer(displayT))
            display(link, window, rectangle, text);
    }

    if (AsmDestroyTimer(displayT))
        AsmPutlstr("AsmDestroyTimer error");
    if (AsmDestroyTimer(updateT))
        AsmPutlstr("AsmDestroyTimer error");
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