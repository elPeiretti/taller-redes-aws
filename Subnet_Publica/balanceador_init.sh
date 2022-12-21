#!/bin/sh

## instalar y correr servidor apache
sudo apt-get update
sudo apt install apache2
systemctl start apache2
