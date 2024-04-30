/*
** EPITECH PROJECT, 2023
** Bonus
** File description:
** bonus.h
*/

#ifndef BONUS_
    #define BONUS_

void *malloc(unsigned long);

void free(void *);

void *calloc(unsigned long, unsigned long);

void *realloc(void *, unsigned long);

void dalloc(void);

char *strdup(const char *);

int putchar(int);

int puts(char *);

int atoi(char *);

char *strcpy(char *, char *);

char *strncpy(char *, char *, unsigned long);

char *strcat(char *, const char *);

char *strncat(char *, const char *, unsigned long);

#endif
