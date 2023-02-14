#!/bin/sh

## instalar y correr servidor apache
sudo apt-get update
sudo apt install apache2
sudo systemctl start apache2

## cambiar el html
sudo rm /var/www/html/index.html
sudo cp ./servidor_privado_index.html /var/www/html/index.html

## reiniciar apache2
sudo systemctl restart apache2

# instalar mysql-client para probar la base de datos
sudo apt install mysql-client

# sudo mysql -u admin -p -h 10.0.0.73 
# password = admin
# "status" para saber si todo está bien