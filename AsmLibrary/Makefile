##
## EPITECH PROJECT, 2023
## MinilibC
## File description:
## Makefile
##

NAME = test

SRC = src/main.c \

OBJ = $(SRC:.c=.o)

CFLAGS = -z execstack -Wall -Wextra -I./include -L./lib -lAsm

all: $(NAME)

$(NAME): $(OBJ)
	make -C lib
	gcc $(OBJ) -o $(NAME) $(CFLAGS)

.PHONY: run

run:
	@$(MAKE) -s re
	@./$(NAME)
	@$(MAKE) -s fclean

debug: fclean $(OBJ)
	@make -s -C lib
	@gcc $(OBJ) -o $(NAME) $(CFLAGS) -g3
	@valgrind ./$(NAME)
	@$(MAKE) -s fclean

clean:
	make -C lib clean
	rm -rf $(OBJ)

fclean: clean
	make -C lib fclean
	rm -rf $(NAME)

re: fclean all
