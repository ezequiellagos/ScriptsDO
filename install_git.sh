#!/bin/bash

# Referencia
# https://www.digitalocean.com/community/tutorials/how-to-install-git-on-ubuntu-18-04#setting-up-git

read -p "¿Realmente desea instalar Git en el sistema? (y/n): " result

if [ "$result" = "y" ]; then
	# Instalación
	sudo apt update
	sudo apt install git
	git --version

	#Configuración
	read -p "Igrese nombre de usuario: " user_conf
	read -p "Igrese correo: " email_conf
	git config --global user.name "${user_conf}"
	git config --global user.email "${email_conf}"

	echo "Git Instalado"
elif [ "$result" = "n" ]; then
	echo "No se instalaló Git en el sistema"
else
	echo "respuesta no valida"
fi
