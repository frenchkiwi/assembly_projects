#include "AsmLibrary.h"
#include "AsmGraphic.h"

int main(int ac, char **av, char **envp)
{
    AsmLink *link = AsmCreateLink(envp);
    AsmWindow *window = AsmCreateWindow(link, (AsmSize){800, 600}, "AsmGraphic Rework");
    AsmFont *font = AsmCreateFont(link, "fixed");
    AsmText *text = AsmCreateText(link, "Bonjour", font, (AsmPos){50, 50});

    if (!link)
        AsmPutlstr("AsmCreateLink error");
    if (!window)
        AsmPutlstr("AsmCreateWindow error");
    if (!font)
        AsmPutlstr("AsmCreateFont error");
    if (!text)
        AsmPutlstr("AsmCreateText error");

    if (AsmOpenWindow(window))
        AsmPutlstr("AsmOpenWindow error");
    for (int i = 0; i < 1000000000; i++);
    if (AsmDrawText(window, text))
        AsmPutlstr("AsmDrawText error");
    if (AsmDisplayWindow(window))
        AsmPutlstr("AsmDisplayWindow error");
    for (int i = 0; i < 1000000000; i++);
    if (AsmCloseWindow(window))
        AsmPutlstr("AsmCloseWindow error");
    for (int i = 0; i < 1000000000; i++);

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