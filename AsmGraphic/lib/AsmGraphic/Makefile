##
## EPITECH PROJECT, 2023
## MinilibC
## File description:
## Makefile
##

NAME = libAsmGraphic.a

SRC = AsmLink/AsmCreateLink.asm \
	  AsmLink/AsmThreadEvent.asm \
	  AsmLink/AsmCloseLink.asm \
	  AsmWindow/AsmCreateWindow.asm \
	  AsmWindow/AsmCloseWindow.asm \
	  AsmWindow/AsmDestroyWindow.asm \

OBJ = $(SRC:.asm=.o)

CFLAGS = -I ../../include

all: $(NAME)

$(NAME): $(OBJ)
	@ar rc $(NAME) $(OBJ)
	@mv $(NAME) ..

%.o: %.asm
	@nasm -f elf64 $< -o $@ $(CFLAGS)

clean:
	@rm -rf $(OBJ)

fclean: clean
	@rm -rf ../$(NAME)

re: fclean all
