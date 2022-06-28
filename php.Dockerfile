FROM php:7.4.7-fpm-alpine

WORKDIR /var/www

RUN apk update && \
    apk add --no-cache build-base vim lynx tzdata

RUN docker-php-ext-install mysqli pdo_mysql

RUN addgroup -g 1000 -S www && \
    adduser -u 1000 -S www -G www

USER www

COPY --chown=www:www ./app_files /var/www

EXPOSE 9000