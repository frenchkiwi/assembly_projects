##
## EPITECH PROJECT, 2023
## MinilibC
## File description:
## Makefile
##

NAME = test

SRC = main.c \

OBJ = $(SRC:.c=.o)

CFLAGS = -I./include -I../bonus/include -L.. -lasm

all: $(NAME)

$(NAME): $(OBJ)
	make -C ..
	gcc $(OBJ) -o $(NAME) $(CFLAGS)

bonus: fclean $(OBJ)
	make -C ..
	make -C ../bonus
	gcc $(OBJ) -o $(NAME) $(CFLAGS) -L../bonus -lbonusasm

.PHONY: run run_bonus

run:
	@$(MAKE) -s re
	@echo "#! /bin/bash" >> run
	@echo "export LD_LIBRARY_PATH=.." >> run
	@echo "export LD_PRELOAD=../libasm.so" >> run
	@echo ./$(NAME) >> run
	@chmod 777 run
	@-./run
	@rm -rf run
	@$(MAKE) -s fclean

run_bonus:
	@$(MAKE) -s bonus
	@echo "#! /bin/bash" >> run
	@echo "export LD_LIBRARY_PATH=..:../bonus" >> run
	@echo "export LD_PRELOAD=\"../libasm.so ../bonus/libbonusasm.so\"" >> run
	@echo "echo \$LD_PRELOAD" >> run
	@echo ./$(NAME) >> run
	@chmod 777 run
	@-./run
	@rm -rf run
	@$(MAKE) -s -C ../bonus fclean
	@$(MAKE) -s fclean


clean:
	make -C .. clean
	rm -rf $(OBJ)

fclean: clean
	make -C .. fclean
	rm -rf $(NAME)

re: fclean all
