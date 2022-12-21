#!/bin/sh

## instalar y arrancar nginx
sudo apt-get update
sudo apt install nginx

/etc/init.d/nginx start
/etc/init.d/nginx status