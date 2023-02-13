#!/bin/bash

# Borrar todas las reglas

iptables -F OUTPUT
iptables -F INPUT
iptables -F FORWARD

# Reglas por defecto

iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP

# Reglas para que se conecte el servidor privado por ssh

iptables -A INPUT -i eth0 -s 10.0.0.28 -d 10.0.0.78 -p tcp --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -s 10.0.0.78 -d 10.0.0.28 -p tcp --sport 22 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

# Reglas para que se conecte el servidor privado al servicio mysql

iptables -A INPUT -i eth0 -s 10.0.0.28 -d 10.0.0.78 -p tcp --sport 1024:65535 --dport 3306 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -s 10.0.0.78 -d 10.0.0.28 -p tcp --sport 3306 --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT

