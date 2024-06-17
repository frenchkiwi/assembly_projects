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

char *AsmStrdup(char *);

char *AsmStrcpy(char *, char const *);

char *AsmStrncpy(char *, char const *, long);

void AsmPrint(char *, ...);

// void my_putcharerror(char);

// void my_putnbr(long long);

// unsigned long my_strlen(char const *);

// void my_putstr(char const *);

// void my_puterror(char const *);

// void my_revstr(char *);

// int my_getnbr(char *);

// AsmMath
long long AsmPower(long long, long long);

// char *my_strdup(char const *);

// char *my_strcat(char *, char const *);

// char *my_strncat(char *, char const *, unsigned long);

// int my_strcmp(char const *, char const *);

// int my_strncmp(char const *, char const *, unsigned long);

// char **my_str_to_word_array(char *, char *);

void *AsmAlloc(unsigned long);

void AsmDalloc(void *);

void *AsmCalloc(unsigned long, unsigned long);

void *AsmRealloc(void *, unsigned long);

void AsmShowMemory(void);
#endif