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

# Reglas para conectarse por ssh desde el servidor VPN
iptables -A INPUT -p tcp -s 10.0.0.54/32 -d 10.0.0.28/32 --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s 10.0.0.28/32 -d 10.0.0.54/32 --sport 22 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas para conectarse con la base de datos a través de ssh
iptables -A INPUT -p tcp -s 10.0.0.73/32 -d 10.0.0.28/32 --sport 22 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s 10.0.0.28/32 -d 10.0.0.73/32 --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT

# Reglas para conectarse con la base de datos
iptables -A INPUT -p tcp -s 10.0.0.73/32 -d 10.0.0.28/32 --sport 3306 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s 10.0.0.28/32 -d 10.0.0.73/32 --sport 1024:65535 --dport 3306 -m state --state NEW,ESTABLISHED -j ACCEPT

# Reglas para conectarse con el servidor VPN
iptables -A INPUT -p tcp -s 10.0.0.54/32 -d 10.0.0.28/32 --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s 10.0.0.28/32 -d 10.0.0.54/32 --sport 80 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Reglas por defecto
iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
