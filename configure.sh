#!/bin/bash

configENV () {
    echo -ne "\033[1;36m \t Enter the time zone for your containers:  \033[0m"
    read RES        
    echo "TZ_V=${RES}" > ./.env
    
    echo -ne "\033[1;36m \t Enter the number of app replicas that you want:  \033[0m"
    read RES        
    echo "SCALE=${RES}" >> ./.env
    
    echo -ne "\033[1;36m \t Enter the MySQL database name:  \033[0m"
    read RES        
    echo "DB_NAME=${RES}" >> ./.env
    
    echo -ne "\033[1;36m \t Enter the MySQL database root password:  \033[0m"
    read RES        
    echo "ROOT_PASS=${RES}" >> ./.env
    
    echo -ne "\033[1;36m \t Enter the MySQL database username:  \033[0m"
    read RES        
    echo "USER_NAME=${RES}" >> ./.env
    
    echo -ne "\033[1;36m \t Enter the MySQL database userpassword:  \033[0m"
    read RES
    echo "USER_PASS=${RES}" >> ./.env
}

clear;



echo $(pwd)
echo -e "\033[0;32m ========== Configuring dockerized Nginx PHP MySQL PHPMyAdmin Mailcow architecture ========== \n \033[0m"

echo -e "\033[1;36m The script is written to be executed on Ubuntu based Linux systems. \n It downloads a simple CRUD CodeIgniter app from git and sets it up with Nginx, PHP, MySQL, PHPMyAdmin, and MailCow. \n The project distributes server's load on a constant number of PHP containers. If you need dynamic creation of containers you should use Kubernetes. \033[0m"

echo -e "\033[0;31m \t - Try to run it with 'sudo' or some parts might not work \n \033[0m"

echo -e "\033[1;36m * Installing necessary packages \033[0m"

sudo apt-get update
 sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    sed \
    perl \
    docker-compose

echo -e "\033[1;36m * Installing git \033[0m"
apt install git 



echo -e "\033[1;36m * Installing docker \033[0m"

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update && \
apt install ca-certificates \
    curl \
    gnupg \
    lsb-release \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

if [ -d ./app_files ]
then
    echo -e "\033[1;36m * app_files directory exists \033[0m"
    echo -ne "\033[0;31m \t Would you like to remove the ./app_files directory? (y/n) YOU WILL LOSE THE DATA THAT YOU HAVE IN IT! \033[0m" 
    read RES
    if [ "$RES" == "y" ]
    then
        rm -r ./app_files
    fi 
else
    echo -e "\033[1;36m * app_files directory doesn't exist and is being created \033[0m"
    mkdir ./app_files
fi
echo -e "\033[1;36m * clonning sample CRUDCodeigniter repository \033[0m"

if [ -z "$(ls -A ./app_files)" ]
then
    echo -e "\033[1;36m \t * clonning \033[0m"
    git clone https://github.com/sajjadhesami/CRUDCodeigniter.git ./app_files/CRUDCodeigniter
else
    echo -e "\033[0;31m \t * clonning skipped because app_files is not empty \033[0m"
fi

if [ -d ./mailcow ]
then
    echo -e "\033[1;36m * mailcow directory exists \033[0m"
    echo -ne "\033[0;31m \t Would you like to remove the ./mailcow directory? (y/n) YOU WILL LOSE THE DATA THAT YOU HAVE IN IT! \033[0m" 
    read RES
    if [ "$RES" == "y" ]
    then
        rm -r ./mailcow
    fi 
else
    echo -e "\033[1;36m * mailcow directory doesn't exist and is being created \033[0m"
    mkdir ./mailcow
fi
echo -e "\033[1;36m * clonning mailcow repository \033[0m"

if [ -z "$(ls -A ./mailcow)" ]
then
    echo -e "\033[1;36m \t * clonning \033[0m"
    git clone https://github.com/mailcow/mailcow-dockerized.git ./mailcow
else
    echo -e "\033[0;31m \t * clonning skipped because mailcow is not empty \033[0m"
fi
echo -e "\033[1;36m * Configuring mailcow by generate_config.sh \033[0m"
cd ./mailcow/ 
./generate_config.sh 

echo -e "\033[1;36m * mailcow Https is set to 127.0.0.1:8443 \033[0m"
sed -i -r 's/HTTPS_PORT=(.*)/HTTPS_PORT=8443/' ./mailcow.conf
sed -i -r 's/HTTPS_BIND=(.*)/HTTPS_BIND=127.0.0.1/' ./mailcow.conf

echo -e "\033[1;36m * mailcow Http is set to 127.0.0.1:8080 \033[0m"

sed -i -r 's/HTTP_PORT=(.*)/HTTP_PORT=8080/' ./mailcow.conf
sed -i -r 's/HTTP_BIND=(.*)/HTTP_BIND=127.0.0.1/' ./mailcow.conf


LINE_NO=$(grep -nP '(.*)? - ("\$\{HTTPS.*)' ./docker-compose.yml | cut -d ":" -f 1)
LINE_NO=$((LINE_NO-1))

sed -i -r "${LINE_NO} s/^/#/" ./docker-compose.yml

sed -i -r 's/(.*)? - ("\$\{HTTPS.*)/\1# - \2/' ./docker-compose.yml
sed -i -r 's/(.*)? - ("\$\{HTTP.*)/\1# - \2/' ./docker-compose.yml

docker compose down -v
docker compose up -d

cd ..

echo -e "\033[1;36m * Configuring .env file \033[0m"

if [ -f "./.env" ]
then
    echo -ne "\033[0;31m \t A .env file already exists. Do you want to delete it? (y/n) if you do not remove the .env file it will be used for the configuration of docker-compose.yml \033[0;31m"
    read RES
    if [ "$RES" == "y" ]
    then
        rm ./.env
        configENV

    fi 
else
    configENV
fi

echo -e "\033[1;36m * Preparing nginx config file \033[0m"

currentdir="$( basename "$PWD" )"
currentdir=${currentdir@L}
str="upstream backend {\n"

n=$(sed -nr '/SCALE=(\d*)/p' ./.env | cut -d '=' -f 2)

for ((i=1;i<=n;i++))
do
    str+="server ${currentdir}-app-${i}:9000;\n"
    docker stop "${currentdir}-app-${i}:9000"
    docker rm "${currentdir}-app-${i}:9000"
done
str+="}"

perl -0pi -e "s#upstream *backend *\{(.|\n|\r)*?\}#$str#gs" ./config/nginx/app.conf

echo -e "\033[1;36m * Preparing mysql \033[0m"

rootPass=$(sed -nr '/ROOT_PASS=(\d*)/p' ./.env | cut -d '=' -f 2)

docker run --rm \
  --name init-mysql \
  -v mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD="$rootPass" \
  -d mysql:latest && docker stop init-mysql

docker compose down
docker compose build
docker compose up -d

for ((i=1;i<=n;i++))
do    
    docker network connect mailcowdockerized_mailcow-network "${currentdir}-app-${i}"
done
docker network connect mailcowdockerized_mailcow-network container_mysql
docker network connect mailcowdockerized_mailcow-network phpmyadmin_container
docker network connect mailcowdockerized_mailcow-network nginx_container

