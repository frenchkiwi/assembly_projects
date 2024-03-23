extern void my_putchar(char);
extern void my_putstr(char *);
extern void my_putnbr(int);
extern char **my_str_to_word_array(char *);
extern char *my_strdup(char *);
extern void my_showmem(char *, int);
extern void *my_malloc(unsigned long);
extern void *my_calloc(unsigned long);
extern void my_free(void *);

#include <stdlib.h>
#include <stdio.h>

int main() {
    char *str = my_malloc(sizeof(char) * 5);
    char *str2 = my_malloc(sizeof(char) * 4);

    str[0] = 'g';
    str[1] = 'a';
    str[2] = 'y';
    str[3] = '\n';
    str[4] = '\0';
    str2[0] = 'p';
    str2[1] = 'd';
    str2[2] = '\n';
    str2[3] = '\0';
    my_putstr(str);
    my_putstr(str2);
    my_free(str);
    str = my_calloc(sizeof(char) * 5);
    my_putstr(str);
    my_putstr(str2);
    return 0;
}
