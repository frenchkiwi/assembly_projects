/*
** EPITECH PROJECT, 2023
** Library
** File description:
** header.h
*/

#ifndef FUNCTIONS_
    #define FUNCTIONS_

int putchar(int);

void putcharerror(char);

void putnbr(long long);

unsigned long strlen(char const *);

void putstr(char const *);

void puterror(char const *);

void revstr(char *);

int getnbr(char *);

long long power(long long, long long);

char *strdup(char const *);

char *strcat(char *, char const *);

char *strncat(char *, char const *, unsigned long);

char *strcpy(char *, char const *);

int strcmp(char const *, char const *);

int strncmp(char const *, char const *, unsigned long);

char **str_to_word_array(char *, char *);

void *malloc(unsigned long);

void free(void *);

void *calloc(unsigned long, unsigned long);

void *realloc(void *, unsigned long);

void show_malloc(void);

#endif
