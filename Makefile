
REQDIR:=./srcs/requirements
NGINX_IMG_NAME:=nginx_local

build-nginx:
	docker build -t $(NGINX_IMG_NAME) $(REQDIR)/nginx
