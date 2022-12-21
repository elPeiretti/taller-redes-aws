#!/bin/sh

## instalar y arrancar nginx
sudo apt-get update
sudo apt install nginx

/etc/init.d/nginx start
/etc/init.d/nginx status

#configuracion del balanceador
sudo rm /etc/nginx/sites-enabled/default
sudo cp ./backend_default /etc/nginx/sites-enabled/

#reiniciar nginx
systemctl restart nginx