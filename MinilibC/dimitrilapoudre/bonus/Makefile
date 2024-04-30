##
## EPITECH PROJECT, 2023
## MinilibC
## File description:
## Makefile
##

NAME = libbonusasm.so

SRC = alloc.asm \
	  print.asm \
	  str.asm \
	  miscellaneous.asm \

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
