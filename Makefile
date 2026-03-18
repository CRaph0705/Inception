# A Makefile is also required and must be located at the root of your directory. It
# must set up your entire application (i.e., it has to build the Docker images using
# docker-compose.yml).

.PHONY : all up down install build start stop status clean fclean re

NAME = inception
LOCALHOST = http://127.0.0.1
DATA_DIR = /home/rcochran/data
COMPOSE_FILE = srcs/docker-compose.yml
COMPOSE = docker compose -f $(COMPOSE_FILE)

all: up

up:
	mkdir -p $(DATA_DIR)/mariadb
	mkdir -p $(DATA_DIR)/wordpress
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down -v

build:
	$(COMPOSE) build

rebuild: down build

status:
	docker ps

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop


clean: down

fclean: clean
	docker image prune -f

re: fclean up



stopall:
	docker stop $$(docker ps -aq) || true

removeallcontainers:
	docker rm $$(docker ps -aq) || true

removeallimg:
	docker rmi -f $$(docker images -aq) || true

cleanvolumes:
	docker system prune -a --volumes -f

cleanrestart: stopall removeallcontainers removeallimg cleanvolumes re
