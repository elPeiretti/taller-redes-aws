#!/bin/bash

# Borrar todas las reglas
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F OUTPUT
iptables -F INPUT
iptables -F FORWARD
iptables -t nat -F PREROUTING
iptables -t nat -F POSTROUTING

# Reglas para conectarse por ssh desde el firewall
iptables -A INPUT -p tcp -s 10.0.0.38/32 -d 10.0.0.54/32 --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s 10.0.0.54/32 -d 10.0.0.38/32 --sport 22 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas para conectarse por ssh hacia cualquier dispositivo de la Subred_Privada
iptables -A INPUT -p tcp -s 10.0.0.16/28 -d 10.0.0.54/32 --sport 22 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s 10.0.0.54/32 -d 10.0.0.16/28 --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT

# Reglas de nateo
iptables -t nat -A POSTROUTING -s 10.0.100.0/24 -o eth0 -j SNAT --to-source 10.0.0.54

# Reglas loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Reglas por defecto
iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
