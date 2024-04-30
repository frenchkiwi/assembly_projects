##
## EPITECH PROJECT, 2023
## MinilibC
## File description:
## Makefile
##

NAME = libAsmGraphic.so

SRC = AsmGraphic.asm

OBJ = $(SRC:.asm=.o)

all: $(NAME)

$(NAME): $(OBJ)
	gcc -shared -o $(NAME) $^ -z execstack

%.o: %.asm
	nasm -f elf64 $< -o $@

clean:
	rm -rf $(OBJ)

fclean: clean
	rm -rf $(NAME)

re: fclean all
