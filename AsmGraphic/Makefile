##
## EPITECH PROJECT, 2023
## MinilibC
## File description:
## Makefile
##

NAME = test

SRC = src/main.c \

OBJ = $(SRC:.c=.o)

CFLAGS = -L./lib -lAsmGraphic -I./include -z execstack -g3

all: $(NAME)

$(NAME): $(OBJ)
	make -C lib
	gcc $(OBJ) -o $(NAME) $(CFLAGS)

.PHONY: run

run:
	@$(MAKE) -s re
	@./$(NAME)
	@$(MAKE) -s fclean

debug:
	@$(MAKE) -s re
	@valgrind ./$(NAME)
	@$(MAKE) -s fclean

clean:
	make -C lib clean
	rm -rf $(OBJ)

fclean: clean
	make -C lib fclean
	rm -rf $(NAME)

re: fclean all
