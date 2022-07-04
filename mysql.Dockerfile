ARG MYSQL_VERSION=latest
FROM mysql:${MYSQL_VERSION}

# (START) Securing your database might need some of the following actions
# You have to run mysql-secure-installation after building the container
# Change root user
# mysql -u root
# rename user 'root'@'localhost' to 'Root'@'localhost';
# flush privileges;
# creating newusers
# CREATE USER 'newUSER'@'localhost' IDENTIFIED BY 'Hello@123'; no need if you have defiened MYSQL_USER
# (END) Securing your database might need some of the following actions

# (START) change backup.sh accordingly to fit your needs
COPY ./config/db/backup.sh /home/backup.sh
# (END) change backup.sh accordingly to fit your needs

RUN chmod 770 /home/backup.sh

# (START) Sometimes it throws an exception because of ca-certificate
RUN rm /etc/apt/sources.list.d/mysql.list
# (END) Sometimes it throws an exception because of ca-certificate

RUN apt update && apt install -y vim ca-certificates git zip unzip cron tzdata dos2unix && cd /home/ && \
         git clone https://github.com/meob/MySAT.git

# (START) change cron.rule accordingly to fit your needs
ADD ./config/db/cron.rule /etc/cron.d/cron.rule

RUN dos2unix /home/backup.sh && dos2unix /etc/cron.d/cron.rule
# (END) change cron.rule accordingly to fit your needs

RUN crontab /etc/cron.d/cron.rule



# (START) further readings about some errors that might occur
# https://stackoverflow.com/questions/58021378/docker-compose-doesnt-start-mysql8-correctly
CMD cron && mysqld --user=mysql
# (END) further readings about some errors that might occur

EXPOSE 3306