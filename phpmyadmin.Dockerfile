FROM phpmyadmin:latest
ARG SERVER_NAME_ARG

RUN apt update -o Acquire::Check-Valid-Until=false && apt install -y vim nano net-tools tzdata

RUN a2enmod ssl
COPY ./ssl /usr/ssl

RUN sed -ri -e 's,80,443,' /etc/apache2/sites-available/000-default.conf
RUN sed -i -e '/^<\/VirtualHost>/i SSLEngine on' /etc/apache2/sites-available/000-default.conf
RUN sed -i -e '/^<\/VirtualHost>/i SSLCertificateFile /usr/ssl/test-ssl.crt' /etc/apache2/sites-available/000-default.conf
RUN sed -i -e '/^<\/VirtualHost>/i SSLCertificateKeyFile /usr/ssl/test-ssl.key' /etc/apache2/sites-available/000-default.conf


RUN echo "ServerName ${SERVER_NAME_ARG}" >> /etc/apache2/apache2.conf


EXPOSE 443