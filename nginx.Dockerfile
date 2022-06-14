ARG NGINX_VER=1.22.0
FROM nginx:${NGINX_VER}-alpine

RUN apk update && apk upgrade && \
    apk add vim lynx openssl apache2-utils

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
    zlib-dev

RUN cd /opt && \
    git clone --depth 1 -b v3/master --single-branch https://github.com/SpiderLabs/ModSecurity.git && \
    cd ModSecurity && \
    git submodule init && \
    git submodule update && \
    ./build.sh && \
    ./configure --prefix=/ModSec && \
    make && \
    make install 
    # export MODSECURITY_INC=/ModSec/include && \
    # export MODSECURITY_LIB=/ModSec/lib 
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
RUN cp /opt/ModSecurity/unicode.mapping /etc/nginx/modsec/

COPY ./config/nginx/app.conf /etc/nginx/conf.d/app.conf
COPY ./app_files/ /var/www
