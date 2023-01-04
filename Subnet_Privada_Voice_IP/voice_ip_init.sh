#!/bin/sh

# todos los permisos
sudo su

## instalar y correr asterisk
apt-get update
apt install asterisk
systemctl start asterisk

## recargar configuraciones en el PBX funcional
asterisk -rvvvv
sip reload
dialplan reload

## reiniciar apache2
systemctl restart apache2
