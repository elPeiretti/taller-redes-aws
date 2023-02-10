#!/bin/bash

# Borrar todas las reglas

iptables -F OUTPUT
iptables -F INPUT
iptables -F FORWARD

# Reglas para poder conectarse por ssh si se necesita

iptables -A INPUT -s 0.0.0.0/0 -d 10.0.0.100/32 -p tcp --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.100/32 -d 0.0.0.0/0 -p tcp --sport 22 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas para ssh para conectarse al resto de las instancias (Proxy por ejemplo)
iptables -A INPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT

# Reglas por defecto

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Reglas para el servidor web público (NAT y FORWARD)

iptables -t nat -A PREROUTING -p tcp --dport 80 -d 10.0.0.100 -i eth0 -j DNAT --to-destination 10.0.0.12
iptables -t nat -A POSTROUTING -p tcp --sport 80 -s 10.0.0.12 -o eth0 -j SNAT --to-source 10.0.0.100

iptables -A FORWARD -p tcp -s 0.0.0.0/0 -d 10.0.0.12/32 --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT 
iptables -A FORWARD -p tcp -s 10.0.0.12 -d 0.0.0.0/0 --sport 80 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT 

# Reglas para el proxy (NAT y FORWARD)

iptables -t nat -A POSTROUTING -p tcp --dport 80 -s 10.0.0.26 -o eth0 -j SNAT --to-source 10.0.0.100

iptables -A FORWARD -p tcp -s 0.0.0.0/0 -d 10.0.0.26/32 --sport 80 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT 
iptables -A FORWARD -p tcp -s 10.0.0.26 -d 0.0.0.0/0 --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT 

iptables -t nat -A POSTROUTING -p tcp --dport 443 -s 10.0.0.26 -o eth0 -j SNAT --to-source 10.0.0.100

iptables -A FORWARD -p tcp -s 0.0.0.0/0 -d 10.0.0.26/32 --sport 443 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT 
iptables -A FORWARD -p tcp -s 10.0.0.26 -d 0.0.0.0/0 --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT 

# Reglas para el servidor privado (NAT y FORWARD)

iptables -t nat -A PREROUTING -p tcp --dport 51820 -d 10.0.0.100 -i eth0 -j DNAT --to-destination 10.0.100.37
iptables -t nat -A POSTROUTING -p tcp --sport 51820 -s 10.0.100.37 -o eth0 -j SNAT --to-source 10.0.0.100

iptables -A FORWARD -p tcp -s 0.0.0.0/0 -d 10.0.100.37/32 --sport 1024:65535 --dport 51820 -m state --state NEW,ESTABLISHED -j ACCEPT 
iptables -A FORWARD -p tcp -s 10.0.100.37 -d 0.0.0.0/0 --sport 51820 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT 