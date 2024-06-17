#include "AsmLibrary.h"

void AsmString(void)
{
    char str[10] = {0};

    AsmPutchar('c');
    AsmPutstr("\ntest\n");
    AsmPutnbr(4);
    AsmPutchar('\n');
    AsmPutnbr(AsmStrlen("test word"));
    AsmPutchar('\n');
    AsmStrcpy(str, "test");
    AsmPutstr(str);
    AsmPutchar('\n');
    AsmStrncpy(str, "test", 2);
    AsmPutstr(str);
    AsmPutchar('\n');
    AsmStrncpy(str, "test", 6);
    AsmPutstr(str);
    AsmPutchar('\n');
    AsmPutnbr(AsmStrcmp("oui", "non"));
    AsmPutchar('\n');
    AsmPutnbr(AsmStrcmp("non", "non"));
    AsmPutchar('\n');
    AsmPutnbr(AsmStrncmp("non", "non", 7));
    AsmPutchar('\n');
    AsmPutnbr(AsmStrncmp("noa", "non", 2));
    AsmPutchar('\n');
    AsmPutnbr(AsmStrncmp("oui", "non", 2));
    AsmPutchar('\n');
    AsmPrint("test : int %d, char %c, string %s, percentage %%\n", 13, 'c', "test");
}

int main(void)
{
    AsmString();
    return 0;
}