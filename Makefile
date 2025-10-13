BASE:=$(shell pwd)/srcs
REQDIR:=./srcs/requirements
NGINX_IMG_NAME:=nginx_local
MARIADB_IMG_NAME:=mariadb_local
WORDPRESS_IMG_NAME:=wordpress_local
WP_DATA_DIR:=/home/$(USER)/wordpress_data
WP_DB_DIR:=/home/$(USER)/wordpress_db

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
	docker compose -f $(BASE)/docker-compose.yml down
	if [ $(shell docker ps -q | wc -l) -ne 0 ]; then \
		docker stop $(shell docker ps -q); \
	fi

clean: down
	if [ $(shell docker ps -aq | wc -l) -ne 0 ]; then \
		docker rm -f $(shell docker ps -aq); \
	fi

fclean: clean
	docker image prune -fa
	docker volume prune -fa
	docker system prune -fa
	if [ $(shell docker volume ls -q | wc -l) -ne 0 ]; then \
                docker volume rm -f $(shell docker volume ls -q); \
        fi
	sudo rm -rf $(WP_DATA_DIR)
	sudo rm -rf $(WP_DB_DIR)

setup:
	false
	sudo echo "127.0.0.1 tblochet.42.fr" >> /etc/hosts
	sudo apt-get update
	sudo apt-get install ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	echo \
		"deb [arch=$(shell dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
		trixie stable" | \
		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
	sudo apt-get install docker-ce \
		docker-ce-cli \
		containerd.io \
		docker-buildx-plugin \
		docker-compose-plugin
	sudo groupadd docker
	sudo usermod -aG docker tblochet

re: fclean all

.PHONY: all build-nginx build-mariadb build-wordpress build down setup clean fclean re
