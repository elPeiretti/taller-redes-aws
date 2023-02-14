#!/bin/sh

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
nano tr0.conf
chmod 600 tp_private_key tp_public_key tr0.conf

## levantar wireguard
systemctl enable --now wg-quick@tr0

# Descomentar el net.ipv4.ip_forward = 1
sudo nano /etc/sysctl.conf

sudo sysctl -p

sudo sysctl --system