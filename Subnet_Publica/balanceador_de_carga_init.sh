#!/bin/sh

## instalar y arrancar nginx
sudo apt-get update
sudo apt install nginx

sudo /etc/init.d/nginx start
sudo /etc/init.d/nginx status

#configuracion del balanceador
sudo rm /etc/nginx/sites-enabled/default
sudo cp ./balanceador_de_carga_default /etc/nginx/sites-enabled/default

#reiniciar nginx
sudo systemctl restart nginx