# A Makefile is also required and must be located at the root of your directory. It
# must set up your entire application (i.e., it has to build the Docker images using
# docker-compose.yml).

.PHONY : all up down install build start stop status clean fclean re help

NAME = inception
LOCALHOST = http://127.0.0.1
DATA_DIR = $(HOME)/data
COMPOSE_FILE = srcs/docker-compose.yml
COMPOSE = docker compose -f $(COMPOSE_FILE)

all: up

up:
	mkdir -p $(DATA_DIR)/mariadb
	mkdir -p $(DATA_DIR)/wordpress
	mkdir -p $(DATA_DIR)/nginx_logs
	mkdir -p $(DATA_DIR)/ftp_logs
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

build:
	$(COMPOSE) build

rebuild:
	$(COMPOSE) up -d --build

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

clean:
	$(COMPOSE) down -v

fclean: clean
	docker image prune -a -f

re: fclean up

help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  all       - Build and start the application (default)"
	@echo "  up        - Start the application"
	@echo "  down      - Stop the application"
	@echo "  build     - Build the Docker images"
	@echo "  rebuild   - Rebuild the Docker images and start the application"
	@echo "  start     - Start the application containers"
	@echo "  stop      - Stop the application containers"
	@echo "  clean     - Stop and remove containers, networks, volumes, and images created by 'up'"
	@echo "  fclean    - Clean all Docker images (use with caution)"
	@echo "  re        - Clean and rebuild the application"

# check-hosts:
#	@grep "$(DOMAIN_NAME)" /etc/hosts || echo "Please add $(DOMAIN_NAME) to /etc/hosts"

# stopall:
# 	docker stop $$(docker ps -aq) || true

# removeallcontainers:
# 	docker rm $$(docker ps -aq) || true

# removeallimg:
# 	docker rmi -f $$(docker images -aq) || true

# cleanvolumes:
# 	docker system prune -a --volumes -f

# cleanrestart: stopall removeallcontainers removeallimg cleanvolumes re
