/*
** EPITECH PROJECT, 2023
** Library
** File description:
** header.h
*/

#ifndef FUNCTIONS_
    #define FUNCTIONS_

int my_putchar(int);

void my_putcharerror(char);

void my_putnbr(long long);

unsigned long my_strlen(char const *);

void my_putstr(char const *);

void my_puterror(char const *);

void my_revstr(char *);

int my_getnbr(char *);

long long my_power(long long, long long);

char *my_strdup(char const *);

char *my_strcat(char *, char const *);

char *my_strncat(char *, char const *, unsigned long);

char *my_strcpy(char *, char const *);

int my_strcmp(char const *, char const *);

int my_strncmp(char const *, char const *, unsigned long);

char **my_str_to_word_array(char *, char *);

void *my_malloc(unsigned long);

void my_free(void *);

void *my_calloc(unsigned long, unsigned long);

void *my_realloc(void *, unsigned long);

void show_malloc(void);

#endif
