FROM nginx:alpine

RUN apk update && apk upgrade && \
    apk add vim lynx openssl apache2-utils
COPY ./config/nginx/app.conf /etc/nginx/conf.d/app.conf

COPY ./app_files/ /var/www
