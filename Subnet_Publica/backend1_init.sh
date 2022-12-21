#!/bin/sh

## instalar y correr servidor apache
sudo apt-get update
sudo apt install apache2
systemctl start apache2

rm /var/www/html/index.html
cp ./backend1_index.html /var/www/html/index.html