FROM postfixadmin:latest
RUN apt update && apt -y install wget nano vim

RUN useradd -r -u 150 -g mail -d /var/vmail -s /sbin/nologin -c "Virtual Mail User" vmail && \
    mkdir -p /var/vmail && \
    chmod -R 770 /var/vmail && \
    chown -R vmail:mail /var/vmail





# COPY ./config/postfix/config.local.php /var/www/postfixadmin/config.local.php
