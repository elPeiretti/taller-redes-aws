#!/bin/sh

## instalar y correr asterisk
sudo apt-get update
sudo apt install asterisk
sudo systemctl start asterisk

## recargar configuraciones en el PBX funcional
sudo asterisk -rvvvv
sudo sip reload
sudo dialplan reload

## reiniciar apache2
sudo systemctl restart apache2
