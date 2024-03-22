extern void my_putchar(char);
extern void my_putstr(char *);
extern void my_putnbr(int);
extern char **my_str_to_word_array(char *);
extern char *my_strdup(char *);
extern void my_showmem(char *, int);
extern void *my_malloc(unsigned long);
extern void my_free(void *);

#include <stdlib.h>
#include <stdio.h>

int main() {
    char *str = my_malloc(sizeof(char) * 4);

    str[0] = 'g';
    str[1] = 'a';
    str[2] = 'y';
    str[3] = 0;
    printf("%s\n", str);
    my_free(str + 1);
    return 0;
}
