NAME = inception

######

all: build

build:
	docker compose -f srcs/docker-compose.yml build

up:
	docker compose -f srcs/docker-compose.yml up -d

down:
	docker compose -f srcs/docker-compose.yml down
	
clean: 
	docker compose -f srcs/docker-compose.yml down -v

fclean: clean
	docker image prune -af

re : fclean all

.PHONY: all build up down clean fclean re
