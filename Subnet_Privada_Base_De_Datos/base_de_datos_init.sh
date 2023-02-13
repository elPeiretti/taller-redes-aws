#!/bin/sh

## instalar mysql
sudo apt-get update
sudo apt-get install mysql-server

# iniciar la base de datos
sudo systemctl start mysql.service

# comprobar que todo esté andando bien
sudo systemctl status mysql.service