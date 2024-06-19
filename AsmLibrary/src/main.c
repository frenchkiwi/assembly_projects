#include "AsmLibrary.h"
#include <stdio.h>
#include <string.h>

void AsmString(void)
{
    char str[10] = {0};
    char **array = (void *)(0);

    AsmPutchar('c');
    AsmPutstr("\ntest\n");
    AsmPutlnbr(4);
    AsmPutlnbr(AsmStrlen("test word"));
    AsmStrcpy(str, "test");
    AsmPutlstr(str);
    AsmStrncpy(str, "test", 2);
    AsmPutlstr(str);
    AsmStrncpy(str, "test", 6);
    AsmPutlstr(str);
    AsmPutlnbr(AsmStrcmp("oui", "non"));
    AsmPutlnbr(AsmStrcmp("non", "non"));
    AsmPutlnbr(AsmStrncmp("non", "non", 7));
    AsmPutlnbr(AsmStrncmp("noa", "non", 2));
    AsmPutlnbr(AsmStrncmp("oui", "non", 2));
    AsmPutlnbr(AsmStrcasecmp("non", "nON"));
    AsmStrcpy(str, "test");
    AsmStrcat(str, "next");
    AsmPutlstr(str);
    AsmStrcpy(str, "test");
    AsmStrncat(str, "next", 2);
    AsmPutlstr(str);
    AsmPutlstr(AsmStrchr("the complex strategie", 'e'));
    AsmPutlstr(AsmStrrchr("the complex strategie", 't'));
    AsmPutlstr(AsmStrpbrk("the complex strategie", "eh"));
    AsmPutlnbr(AsmStrcspn("the complex strategie", "eh"));
    AsmPutlstr(AsmStrstr("yes iiiits a test", "its"));
    AsmPutlstr(AsmMemset(str, 'c', 9));
    AsmPutlstr(AsmMemcpy(str, "test", 4));
    AsmPrint("test : int %d, char %c, string %s, percentage %%\n", 13, 'c', "test");
    array = AsmStrcut(" complex test for know if the     function   work", " \t");
    for (int i = 0; array[i]; i++) {
        AsmPutlstr(array[i]);
        AsmDalloc(array[i]);
    }
    AsmDalloc(array);
}

void AsmMath(void)
{
    AsmPutlnbr(AsmPower(4, 2));
}

void AsmMemory(void)
{
    char *str[3];

    str[0] = AsmAlloc(sizeof(char) * 5);
    str[1] = AsmAlloc(sizeof(char) * 7);
    str[2] = AsmAlloc(sizeof(char) * 2);
    AsmDalloc(str[2]);
    AsmDalloc(str[1]);
    AsmDalloc(str[0]);
    AsmShowMemory();
}

int main(void)
{
    AsmString();
    AsmMath();
    AsmMemory();
    return 0;
}