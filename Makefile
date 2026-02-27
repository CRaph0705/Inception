# A Makefile is also required and must be located at the root of your directory. It
# must set up your entire application (i.e., it has to build the Docker images using
# docker-compose.yml).

.PHONY : all up down install build start stop status clean fclean re

NAME = inception
LOCALHOST = http:`/`/127.0.0.1
DATA_DIR = /home/rcochran/data

all: up

up:
	mkdir -p $(DATA_DIR)/mariadb
	mkdir -p $(DATA_DIR)/wordpress
	docker compose up -d --build

down:
	docker compose down

build:
	docker compose build

clean:
	docker compose down -v

fclean: clean
	docker image prune -f

re: fclean up

rebuild: down build

status:
	docker ps

start:
	docker compose -f docker-compose.yml start

stop:
	docker compose -f docker-compose.yml stop
