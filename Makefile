# A Makefile is also required and must be located at the root of your directory. It
# must set up your entire application (i.e., it has to build the Docker images using
# docker-compose.yml).

.PHONY : all up down install build start stop status

LOCALHOST=http:`/`/127.0.0.1
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
	docker-compose -f .srcs/docker-compose.yml up

down:
	docker-compose -f .srcs/docker-compose.yml down