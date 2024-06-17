#include "AsmLibrary.h"

int main(void)
{
    char *str1 = (void *)(0);
    char *str2 = (void *)(0);
    char *str3 = (void *)(0);

    str1 = AsmStrdup("caca2\n");
    str2 = AsmAlloc(8000);
    str3 = AsmAlloc(12000);
    AsmPutchar('d');
    AsmPutstr("caca\n");
    AsmPutstr(str1);
    AsmPutstr(AsmStrncpy(str2, "caca", 2));
    AsmPutnbr(36);
    AsmPutstr(str2);
    AsmDalloc(str2);
    AsmDalloc(str3);
    AsmDalloc(str1);
    AsmShowMemory();
    return 0;
}