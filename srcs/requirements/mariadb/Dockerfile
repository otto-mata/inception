FROM alpine:3.21

WORKDIR /build
COPY . .

RUN apk update && \
    apk add mariadb mariadb-client

RUN mkdir -p /var/lib/mysqld && \
    chown -R mysql:mysql /var/lib/mysqld && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

RUN /usr/bin/mariadb-install-db --user=mysql --datadir=/var/lib/mysql

RUN cp ./tools/entrypoint /bin/docker_entry && \
    chmod +x /bin/docker_entry

EXPOSE 3306
ENTRYPOINT ["/bin/docker_entry"]
