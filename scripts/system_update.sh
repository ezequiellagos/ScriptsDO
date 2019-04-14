#!/bin/bash

# Referencia
# https://linuxconfig.org/how-to-update-ubuntu-packages-on-18-04-bionic-beaver-linux

read -p "¿Realmente desea actualizar el sistema? (y/n): " result

if [ "$result" = "y" ]; then
	sudo apt -y update
	apt list --upgradable
	sudo apt -y upgrade
	sudo apt -y dist-upgrade
	sudo apt -y autoremove
	echo "Sistema actualizado"
elif [ "$result" = "n" ]; then
	echo "El sistema no se ha actualizado"
else
	echo "respuesta no valida"
fi
