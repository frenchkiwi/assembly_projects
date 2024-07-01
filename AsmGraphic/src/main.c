#include "AsmLibrary.h"
#include "AsmGraphic.h"

int main(int ac, char **av, char **envp)
{
    AsmLink *link = AsmCreateLink(envp);
    AsmWindow *window = AsmCreateWindow(link, (AsmSize){800, 600}, (void *)(0));

    if (!link)
        AsmPutlstr("AsmCreateLink error");
    if (!window)
        AsmPutlstr("AsmCreateWindow error");

    if (AsmOpenWindow(window))
        AsmPutlstr("AsmOpenWindow error");
    for (int i = 0; i < 1000000000; i++);
    if (AsmCloseWindow(window))
        AsmPutlstr("AsmCloseWindow error");
    for (int i = 0; i < 1000000000; i++);

    if (AsmDestroyWindow(window))
        AsmPutlstr("AsmDestoyWindow error");
    if (AsmCloseLink(link))
        AsmPutlstr("AsmCloseLink error");
    AsmShowMemory();
    return 0;
}