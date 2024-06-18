#include "AsmLibrary.h"

void AsmString(void)
{
    char str[10] = {0};
    char **array = (void *)(0);

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
    AsmStrcpy(str, "test");
    AsmStrcat(str, "next\n");
    AsmPutstr(str);
    AsmStrcpy(str, "test");
    AsmStrncat(str, "next\n", 2);
    AsmPutstr(str);
    AsmPutchar('\n');
    AsmPrint("test : int %d, char %c, string %s, percentage %%\n", 13, 'c', "test");
    array = AsmStrcut(" complex test for know if the     function   work", " \t");
    for (int i = 0; array[i]; i++) {
        AsmPutstr(array[i]);
        AsmPutchar('\n');
    }
}

int main(void)
{
    AsmString();
    return 0;
}