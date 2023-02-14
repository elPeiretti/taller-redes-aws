#!/bin/sh

## instalar wireguard
sudo apt-get update
sudo apt install wireguard

## generar claves
sudo cd /etc/wireguard
#crear clave privada
sudo wg genkey > tp_private_key
# crear clave publica
sudo wg pubkey < tp_private_key > tp_public_key

# crear archivo de configuracion
sudo nano tr0.conf
sudo chmod 600 tp_private_key tp_public_key tr0.conf

## levantar wireguard
sudo systemctl enable --now wg-quick@tr0

# Descomentar el net.ipv4.ip_forward = 1
sudo nano /etc/sysctl.conf

sudo sysctl -p

sudo sysctl --system