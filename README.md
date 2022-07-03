# Dockerized-Nginx-Php-Mysql-Phpmyadmin-Mailcow
## Introduction
The project involves a dockerized version of Nginx, Php, MySQL, PhpMyAdmin, and Mailcow. These are generally considered as default requirements of a webserver. The Nginx server distributes the load among a constant number of backend servers.
## Usage
There is a `./configure.sh` bash script that can help you to install the project and have the servers up and running. The `.configure.sh` file starts by installing the main requirements of the project (installing `git`, `docker`, and a few other usual tools).

Later, the script clones a CodeIgniter project from git (just for the sake of testing the servers). In the next step, it clones MailCow from git and runs `./generate_config.sh` script (MailCow's default file configuration script). Finally, it changes the ports of the MailCow web interface and comments the ports section of its `docker-compose.yml`, so that the traffic could be redirected to the mail server through another `Nginx` server.

It runs the docker-compose-up command in the mailcow directory. Then, it receives the configuration parameters from the user and sets up the Nginx, MySQL, PhpMyAdmin, and Php servers. Finally, it connects all containers so they can ping one another.
## Caution
Although the project installs ModSecurity and configures standard rules on it, I should say that the project's security has not been verified by specialists of the field (especially, it should be noted that ModSecurity is disabled on PhpMyAdmin because it was blocking some queries on the database).
## Notice
I am not a professional in server administratorship field, and the development of this project was alongside learning how to use some of the technologies. During development phase, I benefited from many open-source projects and free tutorials.

The project has been presented to the public **as-is**. I will be trying to update the project and improve it from time to time, so I welcome all comments are contributions that you might be willing to give. Feel free to leave a message if you have noticed any problem and/or if you have any suggestions.
