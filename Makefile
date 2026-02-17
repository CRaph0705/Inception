# A Makefile is also required and must be located at the root of your directory. It
# must set up your entire application (i.e., it has to build the Docker images using
# docker-compose.yml).

.PHONY : all up down install build start stop status clean fclean re

NAME = inception
LOCALHOST = http:`/`/127.0.0.1

all: up

install :

build:
	docker compose up --build

open:
	xdg-open $(LOCALHOST)

status:
	docker ps

start:
	docker-compose -f .srcs/docker-compose.yml start

stop:
	docker-compose -f .srcs/docker-compose.yml stop

up:
	docker-compose -d up

down:
	docker-compose -d down

reset:
	docker-compose down -v
	docker system prune -a


clean:

fclean: clean
	docker system prune -a

re: fclean build up