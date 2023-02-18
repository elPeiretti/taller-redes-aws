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

# Reglas por defecto

#iptables -P OUTPUT DROP
#iptables -P INPUT DROP
#iptables -P FORWARD DROP

# Reglas de nateo

iptables -t nat -A POSTROUTING -s 10.0.100.0/24 -o eth0 -j SNAT --to-source 10.0.0.54