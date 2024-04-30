/*
** EPITECH PROJECT, 2023
** Library
** File description:
** header.h
*/

#ifndef MINILIBC_
    #define MINILIBC_

unsigned long strlen(char const *);

int strcmp(char const *, char const *);

int strncmp(char const *, char const *, unsigned long);

char *strstr(const char *, const char *);

char *strchr(const char *, int);

char *strrchr(const char *, int);

long unsigned int strcspn(const char *, const char *);

void *memset(void *, int,  long unsigned int);

void *memcpy(void *, const void *,  long unsigned int);

void *memmove(void *, const void *,  long unsigned int);

int strcasecmp(const char *, const char *);

char *strpbrk(const char *, const char *);

#endif
