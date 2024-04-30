##
## EPITECH PROJECT, 2023
## MinilibC
## File description:
## Makefile
##

NAME = test

SRC = main.c \

OBJ = $(SRC:.c=.o)

CFLAGS = -L./lib -lAsmGraphic -I./include

all: $(NAME)

$(NAME): $(OBJ)
	make -C lib
	gcc $(OBJ) -o $(NAME) $(CFLAGS)

.PHONY: run

run:
	@$(MAKE) -s re
	@echo > run
	@echo "#! /bin/bash" >> run
	@echo "xhost + local: > /dev/null 2>&1" >> run
	@echo export LD_LIBRARY_PATH='"./lib/:$$''LD_LIBRARY_PATH"' >> run
	@echo export LD_PRELOAD='"./lib/libAsmGraphic.so:$$''LD_PRELOAD"' >> run
	@echo ./$(NAME) >> run
	@echo echo exit code: '$$''?' >> run
	@echo "export LD_LIBRARY_PATH=" >> run
	@echo "export LD_PRELOAD=" >> run
	@echo "xhost - local: > /dev/null 2>&1" >> run
	@chmod 777 run
	@-./run
	@rm -rf run
	@$(MAKE) -s fclean

clean:
	make -C lib clean
	rm -rf $(OBJ)

fclean: clean
	make -C lib fclean
	rm -rf $(NAME)

re: fclean all
