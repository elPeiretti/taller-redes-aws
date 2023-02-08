#!/bin/sh

# ser dios
sudo su

## instalar y arrancar nginx
apt-get update
apt install nginx

/etc/init.d/nginx start
/etc/init.d/nginx status

#configuracion del balanceador
rm /etc/nginx/sites-enabled/default
cp ./balanceador_de_cargadefault /etc/nginx/sites-enabled/default

#reiniciar nginx
systemctl restart nginx