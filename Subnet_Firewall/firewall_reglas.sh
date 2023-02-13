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

# Reglas para poder conectarse por ssh si se necesita al firewall
iptables -A INPUT -s 0.0.0.0/0 -d 10.0.0.38/32 -p tcp --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -s 10.0.0.38/32 -d 0.0.0.0/0 -p tcp --sport 22 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas para ssh para conectarse al resto de las instancias desde el firewall (Proxy por ejemplo)
iptables -A INPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT

#### Reglas de NAT
# Reglas para el servidor web público
iptables -t nat -A PREROUTING -p tcp --dport 80 -d 10.0.0.38 -i eth0 -j DNAT --to-destination 10.0.0.7
iptables -t nat -A POSTROUTING -p tcp --sport 80 -s 10.0.0.7 -o eth0 -j SNAT --to-source 10.0.0.38
# Reglas para el proxy
iptables -t nat -A POSTROUTING -p tcp --dport 80 -s 10.0.0.29 -o eth0 -j SNAT --to-source 10.0.0.38
iptables -t nat -A POSTROUTING -p tcp --dport 443 -s 10.0.0.29 -o eth0 -j SNAT --to-source 10.0.0.38
# Reglas para el servidor privado
iptables -t nat -A PREROUTING -p udp --dport 51820  -d 10.0.0.38 -i eth0 -j DNAT --to-destination 10.0.0.28
iptables -t nat -A POSTROUTING -p udp --sport 51820 -s 10.0.0.28 -o eth0 -j SNAT --to-source 10.0.0.38

#### Reglas de FORWARD
# Reglas para el servidor web público (NAT y FORWARD)
iptables -A FORWARD -p tcp -s 0.0.0.0/0 -d 10.0.0.7/32 --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT 
iptables -A FORWARD -p tcp -s 10.0.0.7 -d 0.0.0.0/0 --sport 80 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT 
# Reglas para el proxy
iptables -A FORWARD -p tcp -s 0.0.0.0/0 -d 10.0.0.29/32 --sport 80 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT 
iptables -A FORWARD -p tcp -s 10.0.0.29 -d 0.0.0.0/0 --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT 
iptables -A FORWARD -p tcp -s 0.0.0.0/0 -d 10.0.0.29/32 --sport 443 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT 
iptables -A FORWARD -p tcp -s 10.0.0.29 -d 0.0.0.0/0 --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT 
# Reglas para el servidor privado
iptables -A FORWARD -p udp -s 0.0.0.0/0 -d 10.0.0.28/32 --sport 1024:65535 --dport 51820 -j ACCEPT 
iptables -A FORWARD -p udp -s 10.0.0.28 -d 0.0.0.0/0 --sport 51820 --dport 1024:65535 -j ACCEPT 

# Reglas por defecto DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
