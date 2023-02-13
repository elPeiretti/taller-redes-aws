#!/bin/sh

## instalar y correr servidor apache
sudo apt-get update
sudo apt install apache2
sudo systemctl start apache2

## cambiar el html
sudo rm /var/www/html/index.html
sudo cp ./backend2_index.html /var/www/html/index.html

## reiniciar apache2
sudo systemctl restart apache2