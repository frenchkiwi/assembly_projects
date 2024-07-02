#include "AsmLibrary.h"
#include "AsmGraphic.h"

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
    AsmTimer *displayT = AsmInitTimer(1 / 60.0);

    if (AsmOpenWindow(window))
        AsmPutlstr("AsmOpenWindow error");
    while (1) {
        
        if (AsmTickTimer(updateT))
            update(window, rectangle, text);
        if (AsmTickTimer(displayT))
            display(window, rectangle, text);
    }
    if (AsmCloseWindow(window))
        AsmPutlstr("AsmCloseWindow error");

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