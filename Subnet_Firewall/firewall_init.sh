#!/bin/bash

# Descomentar el net.ipv4.ip_forward = 1
sudo nano /etc/sysctl.conf

sudo sysctl -p

sudo sysctl --system

