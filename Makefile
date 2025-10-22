BASE:=$(shell pwd)/srcs
REQDIR:=./srcs/requirements
NGINX_IMG_NAME:=nginx_local
MARIADB_IMG_NAME:=mariadb_local
WORDPRESS_IMG_NAME:=wordpress_local
WP_DATA_DIR:=/home/$(USER)/data/wordpress_data
WP_DB_DIR:=/home/$(USER)/data/wordpress_db

all: build

$(WP_DATA_DIR):
	mkdir -p $@

$(WP_DB_DIR):
	mkdir -p $@

build: $(WP_DATA_DIR) $(WP_DB_DIR)
	docker compose -f $(BASE)/docker-compose.yml up --build

build-nginx:
	if docker image inspect $(NGINX_IMG_NAME):latest > /dev/null 2>&1; then \
		docker rmi $(NGINX_IMG_NAME):latest; \
	fi
	docker build -t $(NGINX_IMG_NAME) $(REQDIR)/nginx


build-mariadb:
	if docker image inspect $(MARIADB_IMG_NAME):latest > /dev/null 2>&1; then \
		docker rmi $(MARIADB_IMG_NAME):latest; \
	fi
	docker build -t $(MARIADB_IMG_NAME) $(REQDIR)/mariadb

build-wordpress:
	if docker image inspect $(WORDPRESS_IMG_NAME):latest > /dev/null 2>&1; then \
		docker rmi $(WORDPRESS_IMG_NAME):latest; \
	fi
	docker build -t $(WORDPRESS_IMG_NAME) $(REQDIR)/wordpress

down:
	@echo Running 'down'...
	docker compose -f $(BASE)/docker-compose.yml down
	if [ $(shell docker ps -q | wc -l) -ne 0 ]; then \
		docker stop $(shell docker ps -q); \
	fi

clean: down
	@echo Running 'clean'...
	if [ $(shell docker ps -aq | wc -l) -ne 0 ]; then \
		docker rm -f $(shell docker ps -aq); \
	fi

fclean: clean
	@echo Running 'fclean'...
	if [ $(shell docker ps -aq | wc -l) -ne 0 ]; then \
		docker stop $(shell docker ps -qa); \
	fi
	if [ $(shell docker images -qa | wc -l) -ne 0 ]; then \
		docker rmi $(shell docker images -qa); \
	fi
	if [ $(shell docker volume ls -q | wc -l) -ne 0 ]; then \
		docker volume rm $(shell docker volume ls -q); \
	fi
	if [ $(docker network inspect srcs_inception) ]; then \
		docker network rm srcs_inception; \
	fi
	sudo rm -rf $(WP_DATA_DIR)
	sudo rm -rf $(WP_DB_DIR)

re: fclean all

.PHONY: all build-nginx build-mariadb build-wordpress build down setup clean fclean re
