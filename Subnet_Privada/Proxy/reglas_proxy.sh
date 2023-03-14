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
iptables -A INPUT -p tcp -s 10.0.0.54/32 -d 10.0.0.29/32 --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s 10.0.0.29/32 -d 10.0.0.54/32 --sport 22 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas para conectarse con el servidor VPN
iptables -A INPUT -p tcp -s 10.0.0.54/32 -d 10.0.0.29/32 --sport 1024:65535 --dport 3128 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s 10.0.0.29/32 -d 10.0.0.54/32 --sport 3128 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas para que el tráfico circule hacia el firewall
iptables -A INPUT -p tcp -s 0.0.0.0/0 -d 10.0.0.29/32 --sport 80 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s 10.0.0.29/32 -d 0.0.0.0/0 --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT

iptables -A INPUT -p tcp -s 0.0.0.0/0 -d 10.0.0.29/32 --sport 443 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s 10.0.0.29/32 -d 0.0.0.0/0 --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT

# Reglas DNS
iptables -A INPUT -p udp -s 10.0.0.2/32 --sport 53 -j ACCEPT
iptables -A OUTPUT -p udp -d 10.0.0.2/32 --dport 53 -j ACCEPT

# Reglas loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Reglas por defecto
iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
