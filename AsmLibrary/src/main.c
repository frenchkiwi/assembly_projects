#include "AsmLibrary.h"

void AsmString(void)
{
    char str[10] = {0};
    char **array = (void *)(0);

    AsmPutchar('c');
    AsmPutstr("\ntest\n");
    AsmPutnbrL(4);
    AsmPutnbrL(AsmStrlen("test word"));
    AsmStrcpy(str, "test");
    AsmPutstrL(str);
    AsmStrncpy(str, "test", 2);
    AsmPutstrL(str);
    AsmStrncpy(str, "test", 6);
    AsmPutstrL(str);
    AsmPutnbrL(AsmStrcmp("oui", "non"));
    AsmPutnbrL(AsmStrcmp("non", "non"));
    AsmPutnbrL(AsmStrncmp("non", "non", 7));
    AsmPutnbrL(AsmStrncmp("noa", "non", 2));
    AsmPutnbrL(AsmStrncmp("oui", "non", 2));
    AsmStrcpy(str, "test");
    AsmStrcat(str, "next");
    AsmPutstrL(str);
    AsmStrcpy(str, "test");
    AsmStrncat(str, "next", 2);
    AsmPutstrL(str);
    AsmPrint("test : int %d, char %c, string %s, percentage %%\n", 13, 'c', "test");
    array = AsmStrcut(" complex test for know if the     function   work", " \t");
    for (int i = 0; array[i]; i++)
        AsmPutstrL(array[i]);
}

void AsmAllocation(void)
{
    AsmAlloc(sizeof(char) * 5);

}

int main(void)
{
    AsmString();
    AsmAllocation();
    return 0;
}