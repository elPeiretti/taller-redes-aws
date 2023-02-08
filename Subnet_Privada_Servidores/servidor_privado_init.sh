#!/bin/sh

## instalar y correr servidor apache
sudo apt-get update
sudo apt install apache2
systemctl start apache2

## cambiar el html
rm /var/www/html/index.html
cp ./servidor_privado_index.html /var/www/html/index.html

## reiniciar apache2
systemctl restart apache2

## instalar wireguard
sudo apt install wireguard

sudo su
## generar claves
cd /etc/wireguard
#crear clave privada
wg genkey > tp_private_key
# crear clave publica
wg pubkey < tp_private_key > tp_public_key

# crear archivo de configuracion
vi tr0.conf
chmod 600 tp_private_key tp_public_key tr0.conf

## levantar wireguard
systemctl enable --now wg-quick@tr0

## habilitar el enrutamiento
echo "1" > /proc/sys/net/ipv4/ip_forward