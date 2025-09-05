FROM alpine:3.21

WORKDIR /build
COPY . .

RUN apk update && \
    apk add nginx \
    openssl

RUN adduser -D -g 'www' www && \
    mkdir /var/www/html && \
    chown -R www:www /var/www/html

RUN mkdir -p /etc/nginx/ssl

RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old && \
    cp ./conf/nginx.conf /etc/nginx/nginx.conf

RUN cp ./tools/entrypoint /bin/docker_entry && \
    chmod +x /bin/docker_entry

EXPOSE 443

ENTRYPOINT ["/bin/docker_entry"]
