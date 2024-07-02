#include "AsmLibrary.h"
#include "AsmGraphic.h"

void analyze_event(AsmEvent event, AsmWindow *window)
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
            break;
        case AsmEventMouseButtonRelease:
            AsmPrint("Button release: %d\n", AsmBUTTON(event));
            break;
        case AsmEventSpecial:
            AsmPutlstr("Oue j'uis special");
            if (AsmCloseWindow(window))
                AsmPutlstr("AsmCloseWindow error");
            break;
        default:
            AsmPrint("Event unknow: %d\n", AsmTYPE(event));
    }
}

void update(AsmWindow *window, AsmRectangle *rectangle, AsmText *text)
{
    return;
}

void display(AsmWindow *window, AsmRectangle *rectangle, AsmText *text)
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
            analyze_event(event, window);
        if (AsmTickTimer(updateT))
            update(window, rectangle, text);
        if (AsmTickTimer(displayT))
            display(window, rectangle, text);
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