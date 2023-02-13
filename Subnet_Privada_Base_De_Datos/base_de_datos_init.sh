#!/bin/sh

## instalar mysql
sudo apt-get update
sudo apt-get install mysql-server

# iniciar la base de datos
sudo systemctl start mysql.service

# comprobar que todo esté andando bien
sudo systemctl status mysql.service

# Cambiar ip bind-address por la de la base de datos
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf

# restart del servicio mysql
sudo systemctl restart mysql

# para entrar al servicio de mysql
sudo mysql

# crear un usuario
CREATE USER 'admin'@'10.0.0.28' IDENTIFIED BY 'admin';

# usuario creado con todos los privilegios
GRANT ALL PRIVILEGES on *.* TO 'admin'@'10.0.0.28';