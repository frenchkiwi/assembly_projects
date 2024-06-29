#include "AsmLibrary.h"
#include "AsmGraphic.h"

int main(int ac, char **av, char **envp)
{
    AsmLink *link = AsmCreateLink(envp);

    AsmPrint("%d\n", link);
    // AsmCloseLink(link);
    return 0;
}