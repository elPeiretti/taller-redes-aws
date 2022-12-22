#!/bin/sh

## instalar squid
sudo apt-get update
sudo apt-get install squid

## navegar al directorio y cambiar el archivo de configuracion
sudo rm /etc/squid/squid.conf
sudo cp ./squid.conf /etc/squid/squid.conf
sudo cp ./dominios.squid /etc/squid/

## reiniciar squid
sudo systemctl restart squid