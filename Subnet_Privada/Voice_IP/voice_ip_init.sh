#!/bin/sh

## instalar y correr asterisk

sudo apt-get update
sudo apt install asterisk
sudo systemctl start asterisk

# cambiar archivos

cd /etc/asterisk
# Agregar las líneas escritas en extensions.conf
sudo nano extensions.conf
# Agregas las líneas escritas en sip.conf
sudo nano sip.conf

## entrar a la consola de asterisk

sudo asterisk -rvvvv

# poner los siguientes comandos

# sip reload
# dialplan reload

# reiniciar asterisk

sudo systemctl restart asterisk