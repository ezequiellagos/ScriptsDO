#!/bin/bash

read -p "¿Desea instalar MySQL 5.7+? (y/n): " result

if [ "$result" = "y" ]; then
	echo "Comenzando instalación..."

	sudo apt update
	sudo apt install mysql-server
	sudo mysql_secure_installation
	systemctl status mysql.service

elif [ "$result" = "n" ]; then
	echo "No se instalará MySQL 5.7+"
else
	echo "Respuesta no válida"
fi
