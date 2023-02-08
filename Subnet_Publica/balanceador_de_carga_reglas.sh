#!/bin/bash

# Borrar todas las reglas

iptables -F OUTPUT
iptables -F INPUT
iptables -F FORWARD

# Reglas para poder conectarse por ssh si se necesita
# Se permite desde cualquier IP porque Amazon la cambia automáticamente

iptables -A INPUT -i eth0 -p tcp --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 22 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas por defecto

iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP

# Reglas para permitir el trafico http y https desde afuera

iptables -A INPUT -i eth0 -p tcp --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 80 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 443 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas para permitir el trafico desde el proxy
iptables -A INPUT -i eth0 -s 10.0.0.26 -d 10.0.0.12 -p tcp --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -s 10.0.0.12 -d 10.0.0.26 -p tcp --sport 80 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -s 10.0.0.26 -d 10.0.0.12 -p tcp --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -s 10.0.0.12 -d 10.0.0.26 -p tcp --sport 443 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT


