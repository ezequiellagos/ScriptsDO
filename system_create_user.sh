#!/bin/bash

# Referencia
# https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04

read -p "Nombre de Nuevo Usuario: " newUser

adduser $newUser
usermod -aG sudo $newUser

echo "Usuario $newUser Creado"
