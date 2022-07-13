ARG NGINX_VER=1.22.0
FROM nginx:${NGINX_VER}-alpine

RUN apk update && \
    apk add vim lynx openssl apache2-utils curl tzdata zip unzip

RUN apk add --no-cache --virtual general-dependencies \
    autoconf \
    automake \
    byacc \
    curl-dev \
    flex \
    g++ \
    gcc \
    geoip-dev \
    git \
    libc-dev \
    libmaxminddb-dev \
    libstdc++ \
    libtool \
    libxml2-dev \
    linux-headers \
    lmdb-dev \
    make \
    openssl-dev \
    pcre-dev \
    yajl-dev \
    zlib-dev \
    busybox-extras \
    bash

RUN cd /opt && \
    git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity.git && \
    cd ModSecurity && \
    git submodule init && \
    git submodule update && \
    ./build.sh && \
    ./configure --prefix=/ModSec && \
    make && \
    make install 
    
ENV MODSECURITY_INC=/ModSec/include                                                                                                        
ENV MODSECURITY_LIB=/ModSec/lib                                                                                                        

RUN cd .. && \ 
    git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git && \    
    wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && tar -xzvf nginx-${NGINX_VERSION}.tar.gz && \        
    cd nginx-${NGINX_VERSION} && \
    ./configure --with-compat --prefix=/nginx-ModSec --add-dynamic-module=../ModSecurity-nginx && \        
    make && \
    make install && \
    cp /nginx-ModSec/modules/ngx_http_modsecurity_module.so /etc/nginx/modules/ngx_http_modsecurity_module.so && \
    sed -i "3i load_module /etc/nginx/modules/ngx_http_modsecurity_module.so;" /etc/nginx/nginx.conf
COPY ./ssl /usr/ssl
COPY ./config/modsec /etc/nginx/modsec
RUN cp /opt/ModSecurity/unicode.mapping /etc/nginx/modsec/ && rm /var/log/nginx/*

COPY ./config/nginx/conf.d/app.conf /etc/nginx/conf.d/app.conf
COPY ./app_files/ /var/www

ADD ./config/nginx/backup/cron.rule /etc/cron.d/cron.rule
COPY ./config/nginx/backup/backup.sh /home/backup.sh
RUN dos2unix /home/backup.sh && dos2unix /etc/cron.d/cron.rule

RUN crontab /etc/cron.d/cron.rule

CMD crond && nginx -g "daemon off;";
