/*
** EPITECH PROJECT, 2023
** assembly_projects
** File description:
** AsmLib.h
*/

#ifndef AsmLib_
    #define AsmLib_

// AsmString
char AsmPutchar(char c);

void AsmPutstr(char const *str);

void AsmPutlstr(char const *str);

char AsmIsNum(char const *str);

long AsmGetnbr(char const *str);

char *AsmGetstr(long n);

void AsmPutnbr(long n);

void AsmPutlnbr(long n);

int AsmStrlen(char *str);

char *AsmStrcpy(char *dest, char const *src);

char *AsmStrncpy(char *dest, char const *src, unsigned long n);

char AsmStrcmp(char const *str1, char const *str2);

char AsmStrncmp(char const *str1, char const *str2, unsigned long n);

char AsmStrcasecmp(char const *str1, char const *str2);

char *AsmStrcat(char *dest, char const *src);

char *AsmStrncat(char *dest, char const *src, unsigned long n);

char *AsmStrchr(char const *str, char c);

char *AsmStrrchr(char const *str, char c);

char *AsmStrpbrk(char const *str, char const *find);

long AsmStrcspn(char const *str, char const *find);

char *AsmStrstr(char const *str, char const *find);

void *AsmMemset(void *ptr, char c, long n);

void *AsmMemcpy(void *dest, void const *src, long n);

void *AsmMemmove(void *dest, void const *src, long n);

void AsmPrint(char const *format, ...);

char **AsmStrcut(char *str, char *delimiters);

// AsmMath
long long AsmPower(long long nb, long long power);

// AsmMemory
void *AsmAlloc(unsigned long size);

void AsmDalloc(void *addr);

void *AsmCalloc(unsigned long size, char c);

void *AsmRealloc(void *addr, unsigned long size);

char *AsmStrdup(char const *str);

void *AsmGetptr(void *addr);

void AsmShowMemory(void);

void AsmClearMemory(void);

#endif