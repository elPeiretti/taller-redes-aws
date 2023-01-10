#!/bin/sh

# super usuario
sudo su

## instalar mysql
apt-get update
apt-get install mysql-server

# iniciar la base de datos
systemctl start mysql.service

# comprobar que todo esté andando bien
systemctl status mysql.service