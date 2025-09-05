FROM alpine:3.21

WORKDIR /build
COPY . .

RUN apk update && \
	apk add php82-curl \
	php82-gd \
	php82-mbstring \
	php82-session \
	php82-opcache \
	php82-zlib \
	wget \
	php82 \
	php82-phar \
	php82-mysqli \
	php82-fpm \
	mariadb-client

RUN mkdir -p /var/www/html

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	--output-document=/bin/wp && \
	chmod +x /bin/wp

RUN ln -sv /usr/bin/php82 /usr/bin/php && \
	ln -sv /usr/sbin/php-fpm82 /usr/sbin/php-fpm

RUN adduser -D wordpress -g wordpress && \
	chown wordpress:wordpress -R /var/www/html && \
	chmod -R o+rw /var/www/html && \
	chmod -R o+rw /var/log/php82/

RUN cp ./tools/entrypoint /bin/docker_entry && \
	chmod +x /bin/docker_entry

RUN cp ./conf/php-fpm.conf /etc/php82/php-fpm.d/www.conf && \
	sed -i 's/^memory_limit\s*=.*/memory_limit = 1024M/' /etc/php82/php.ini

CMD ["/bin/docker_entry"]
