A Makefile is also required and must be located at the root of your directory. It
must set up your entire application (i.e., it has to build the Docker images using
docker-compose.yml).

.PHONY : all clean fclean re install

# CC			= 	c++
# CFLAGS		=	-Wall -Werror -Wextra -std=c++98
# NAME		=	exe
# OBJ_DIR		=	obj/
# SRC			=	src/
# INCLUDES	=	-I ./includes -MMD -MP
# FILES		= 	$(MAIN)$(EXT) \


# EXT			=	.cpp
# OBJ			=	$(patsubst $(SRC)%$(EXT), $(OBJ_DIR)%.o, $(FILES))

# MAIN		= 	$(SRC)main
# all : $(NAME)

# clean :
# 	rm -rf $(OBJ_DIR)

# fclean : clean
# 	rm -f $(NAME)

# re : fclean all

# $(NAME) : $(OBJ_DIR) $(OBJ)
# 	$(CC) $(CFLAGS) $(OBJ) $(INCLUDES) -o $(NAME)

# $(OBJ_DIR)%.o: $(SRC)%.cpp
# 	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# $(OBJ_DIR) :
# 	mkdir $(OBJ_DIR)

install :