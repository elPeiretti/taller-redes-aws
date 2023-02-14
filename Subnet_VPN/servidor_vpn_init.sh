#!/bin/sh

## instalar wireguard
sudo apt-get update
sudo apt install wireguard

# acceder a la carpeta /etc/wireguard
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
nano /etc/sysctl.conf

sysctl -p

sysctl --system