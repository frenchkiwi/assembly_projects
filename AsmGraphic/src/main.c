#include "AsmLibrary.h"
#include "AsmGraphic.h"

int main(int ac, char **av, char **envp)
{
    AsmLink *link = AsmCreateLink(envp);
    AsmWindow *window = AsmCreateWindow(link, (AsmSize){800, 600}, "Test");

    if (!link)
        AsmPutlstr("AsmCreateLink error");
    if (!window)
        AsmPutlstr("AsmCreateWindow error");
    if (AsmDestroyWindow(window))
        AsmPutlstr("AsmDestoyWindow error");
    if (AsmCloseLink(link))
        AsmPutlstr("AsmCloseLink error");
    AsmShowMemory();
    return 0;
}