#!/bin/bash

# Referencia
# https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04

# Update System
./system_update.sh

# Firewall
ufw allow OpenSSH
ufw enable
