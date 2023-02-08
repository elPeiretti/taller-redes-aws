#!/bin/bash

# Borrar todas las reglas

iptables -F OUTPUT
iptables -F INPUT
iptables -F FORWARD

# Reglas para poder conectarse por ssh si se necesita
# Se permite desde cualquier IP porque Amazon la cambia automáticamente

iptables -A INPUT -p tcp --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas por defecto

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Reglas para permitir el trafico http y https desde afuera

iptables -A INPUT -s 0.0.0.0/0 -d 10.0.0.14/32 -p tcp --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.14/32 -d 0.0.0.0/0 -p tcp --sport 80 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -s 0.0.0.0/0 -d 10.0.0.14/32 -p tcp --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.14/32 -d 0.0.0.0/0 -p tcp --sport 443 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas para permitir el trafico desde/hasta el proxy
iptables -A INPUT -s 10.0.0.26/32 -d 10.0.0.14/32 -p tcp --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.14/32 -d 10.0.0.26/32 -p tcp --sport 80 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -s 10.0.0.26/32 -d 10.0.0.14/32 -p tcp --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.14/32 -d 10.0.0.26/32 -p tcp --sport 443 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas para permitir desde/hasta el Backend1
iptables -A INPUT -s 10.0.0.4/32 -d 10.0.0.14/32 -p tcp --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.14/32 -d 10.0.0.4/32 -p tcp --sport 80 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -s 10.0.0.4/32 -d 10.0.0.14/32 -p tcp --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.14/32 -d 10.0.0.4/32 -p tcp --sport 443 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT


# Reglas para permitir desde/hasta el Backend2
iptables -A INPUT -s 10.0.0.13/32 -d 10.0.0.14/32 -p tcp --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.14/32 -d 10.0.0.13/32 -p tcp --sport 80 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -s 10.0.0.13/32 -d 10.0.0.14/32 -p tcp --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.14/32 -d 10.0.0.13/32 -p tcp --sport 443 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
