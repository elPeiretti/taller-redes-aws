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

# Reglas para poder conectarse por ssh si se necesita desde el balanceador de carga
iptables -A INPUT -s 10.0.0.7/32 -d 10.0.0.8/32 -p tcp --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.8/32 -d 10.0.0.7/32 -p tcp --sport 22 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas para permitir el trafico http y https desde/hacia balanceador de carga
iptables -A INPUT -s 10.0.0.7/32 -d 10.0.0.8/32 -p tcp --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.8/32 -d 10.0.0.7/32 -p tcp --sport 80 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -s 10.0.0.7/32 -d 10.0.0.8/32 -p tcp --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.8/32 -d 10.0.0.7/32 -p tcp --sport 443 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Reglas por defecto
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP