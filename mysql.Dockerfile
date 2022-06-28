ARG MYSQL_VERSION=latest
FROM mysql:${MYSQL_VERSION}
# You have to run mysql-secure-installation after building the container
# Change root user
#  mysql -u root
#  rename user 'root'@'localhost' to 'Root'@'localhost';
#  flush privileges;
#  CREATE USER 'newUSER'@'localhost' IDENTIFIED BY 'Hello@123'; no need if you have defiened MYSQL_USER

COPY ./config/db/backup.sh /home/backup.sh
RUN chmod 770 /home/backup.sh
# (START) Sometimes it throws an exception because of ca-certificate
RUN rm /etc/apt/sources.list.d/mysql.list
# (END) Sometimes it throws an exception because of ca-certificate

RUN apt update && apt install -y vim ca-certificates git zip unzip cron && cd /home/ && \
         git clone https://github.com/meob/MySAT.git

ADD ./config/db/root /etc/cron.d/root-cron

RUN crontab /etc/cron.d/root-cron



# (START) uncomment if you want to take backups
# https://stackoverflow.com/questions/58021378/docker-compose-doesnt-start-mysql8-correctly
CMD mysqld --user=mysql && cron
# (END) uncomment if you want to take backups

# GRANT ALL PRIVILEGES ON myTest. * TO 'dev'@'%';

EXPOSE 3306