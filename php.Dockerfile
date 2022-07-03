FROM php:7.4.7-fpm-alpine

WORKDIR /var/www

RUN apk update && \
    apk add --no-cache build-base vim lynx tzdata

RUN docker-php-ext-install mysqli pdo_mysql


RUN echo 'pm.max_children = 15' >> /usr/local/etc/php-fpm.d/zz-docker.conf && \
    echo 'pm.max_requests = 500' >> /usr/local/etc/php-fpm.d/zz-docker.conf

COPY ./app_files /var/www

EXPOSE 9000