ARG MYSQL_VERSION=latest
FROM mysql:${MYSQL_VERSION}
# You have to run mysql-secure-installation after building the container
# Change root user
#  mysql -u root
#  rename user 'root'@'localhost' to 'Root'@'localhost';
#  flush privileges;
#  CREATE USER 'newUSER'@'localhost' IDENTIFIED BY 'Hello@123'; no need if you have defiened MYSQL_USER
RUN apt update && apt install -y ca-certificates git && cd /home/ && \
       git clone https://github.com/meob/MySAT.git

# RUN addgroup db_users && \
#     adduser db_user && \
#     adduser db_user db_users && \
#     chown db_user:db_users /usr && \
#     chown db_user:db_users /var && \
#     chown db_user:db_users /var/run/mysqld/ && \
#     chown db_user:db_users /var/lib/mysql/ && \
#     chmod 600 /etc/mysql/my.cnf && \
#     chmod 777 /var/run/mysqld/ && \
#     chmod 755 /var/lib/mysql/

# USER db_user

# RUN mkdir -p /var/run/mysqld/ && \    
#     mkdir -p /var/lib/mysql-files

# COPY --chown=db_user:db_users ./config/db_config/my.cnf  /etc/mysql/my.cnf


EXPOSE 3306