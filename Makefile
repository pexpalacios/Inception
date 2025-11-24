NAME = inception

#########

all: build

build:
	sudo docker-compose -f srcs/docker-compose.yml build

up:
	sudo docker-compose -f srcs/docker-compose.yml up -d

down:
	sudo docker-compose -f srcs/docker-compose.yml down

clean:
	sudo docker-compose -f srcs/docker-compose.yml down -v

fclean: clean
	sudo docker image prune -af

re: fclean all

.PHONY: all build up down clean fclean re
