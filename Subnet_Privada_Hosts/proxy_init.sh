#!/bin/sh

## instalar squid
sudo apt-get update
sudo apt-get install squid

## cambiar el archivo de configuracion
sudo rm /etc/squid/squid.conf
sudo cp ./squid.conf /etc/squid/squid.conf
sudo cp ./dominios.squid /etc/squid/

## reiniciar squid
sudo systemctl restart squid

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