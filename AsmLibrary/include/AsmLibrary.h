/*
** EPITECH PROJECT, 2023
** assembly_projects
** File description:
** AsmLib.h
*/

#ifndef AsmLib_
    #define AsmLib_
#include <stdarg.h>

// AsmString
char AsmPutchar(char c);

void AsmPutstr(char *str);

void AsmPutstrL(char *str);

void AsmPutnbr(long n);

void AsmPutnbrL(long n);

int AsmStrlen(char *str);

char *AsmStrcpy(char *dest, char const *src);

char *AsmStrncpy(char *dest, char const *src, unsigned long n);

char AsmStrcmp(char const *str1, char const *str2);

char AsmStrncmp(char const *str1, char const *str2, unsigned long n);

char *AsmStrcat(char *dest, char const *src);

char *AsmStrncat(char *dest, char const *src, unsigned long n);

void AsmPrint(char *format, ...);

char **AsmStrcut(char *str, char *delimiters);

// AsmMath
long long AsmPower(long long nb, long long power);

// AsmAlloc
void *AsmAlloc(unsigned long size);

void AsmDalloc(void *addr);

void *AsmCalloc(unsigned long size, char c);

void *AsmRealloc(void *addr, unsigned long size);

char *AsmStrdup(char *str);

void *AsmGetptr(void *addr);

void AsmShowMemory(void);
#endif