#include "AsmLibrary.h"
#include "AsmGraphic.h"

int main(int ac, char **av, char **envp)
{
    AsmLink *link = AsmCreateLink(envp);
    AsmWindow *window = AsmCreateWindow(link, (AsmSize){800, 600}, "Test");

    AsmDestroyWindow(link, window);
    AsmCloseLink(link);
    AsmShowMemory();
    return 0;
}