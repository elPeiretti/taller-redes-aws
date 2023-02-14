#!/bin/bash

# Borrar todas las reglas

iptables -F OUTPUT
iptables -F INPUT
iptables -F FORWARD

# Reglas por defecto

iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
