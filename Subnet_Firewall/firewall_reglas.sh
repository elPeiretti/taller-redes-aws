#!/bin/bash

# Borrar todas las reglas

iptables -F OUTPUT
iptables -F INPUT
iptables -F FORWARD

# Reglas para poder conectarse por ssh si se necesita

iptables -A INPUT -s 0.0.0.0/0 -d 10.0.0.100/32 -p tcp --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.100/32 -d 0.0.0.0/0 -p tcp --sport 22 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas por defecto

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Reglas para el servidor web público (NAT)

iptables -t nat -A PREROUTING -p tcp --dport 80 -d 10.0.0.106 -i eth0 -j DNAT --to-destination 10.0.0.12
iptables -t nat -A POSTROUTING -p tcp --sport 80 -s 10.0.0.12 -o eth0 -j SNAT --to-source 10.0.0.106



