#!/bin/bash

# Borrar todas las reglas

iptables -F OUTPUT
iptables -F INPUT
iptables -F FORWARD

# Reglas para poder conectarse por ssh si se necesita

iptables -A INPUT -s 0.0.0.0/0 -d 10.0.0.4/32 -p tcp --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.4/32 -d 0.0.0.0/0 -p tcp --sport 22 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas por defecto

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Reglas para permitir el trafico http y https desde/hacia balanceador de carga
iptables -A INPUT -s 10.0.0.12/32 -d 10.0.0.4/32 -p tcp --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.4/32 -d 10.0.0.12/32 -p tcp --sport 80 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -s 10.0.0.12/32 -d 10.0.0.4/32 -p tcp --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.4/32 -d 10.0.0.12/32 -p tcp --sport 443 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT