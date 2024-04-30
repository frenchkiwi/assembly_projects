##
## EPITECH PROJECT, 2023
## MinilibC
## File description:
## Makefile
##

NAME = libasm.so

SRC = strlen.asm \
	  strcmp.asm \
	  strncmp.asm \
	  strstr.asm \
	  strchr.asm \
	  strrchr.asm \
	  strcspn.asm \
	  memset.asm \
	  memcpy.asm \

OBJ = $(SRC:.asm=.o)

all: $(NAME)

$(NAME): $(OBJ)
	gcc -shared -o $@ $^ -z execstack

%.o: %.asm
	nasm -f elf64 $< -o $@

clean:
	rm -rf $(OBJ)

fclean: clean
	rm -rf $(NAME)

re: fclean all
