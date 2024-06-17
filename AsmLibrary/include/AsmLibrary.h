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
char AsmPutchar(char);

void AsmPutstr(char *);

void AsmPutnbr(long);

int AsmStrlen(char *);

char *AsmStrcpy(char *, char const *);

char *AsmStrncpy(char *, char const *, unsigned long);

char AsmStrcmp(char const *, char const *);

char AsmStrncmp(char const *, char const *, unsigned long);

char *AsmStrcat(char *, char const *);

char *AsmStrncat(char *, char const *, unsigned long);

void AsmPrint(char *, ...);

// void my_putcharerror(char);

// void my_puterror(char const *);

// void my_revstr(char *);

// int my_getnbr(char *);

// AsmMath
long long AsmPower(long long, long long);

// char **my_str_to_word_array(char *, char *);

void *AsmAlloc(unsigned long);

void AsmDalloc(void *);

void *AsmCalloc(unsigned long, unsigned long);

void *AsmRealloc(void *, unsigned long);

char *AsmStrdup(char *);

void AsmShowMemory(void);
#endif