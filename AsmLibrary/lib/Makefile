##
## EPITECH PROJECT, 2023
## MinilibC
## File description:
## Makefile
##

NAME = libAsm.a

SRC = AsmAlloc.asm \
	  AsmMath.asm \
	  AsmString.asm \

OBJ = $(SRC:.asm=.o)

CFLAGS = -I ../include

all: $(NAME)

$(NAME): $(OBJ)
	ar rc $(NAME) $(OBJ)

%.o: %.asm
	nasm -f elf64 $< -o $@ $(CFLAGS)

clean:
	rm -rf $(OBJ)

fclean: clean
	rm -rf $(NAME)

re: fclean all
