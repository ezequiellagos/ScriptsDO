#!/bin/bash

read -p "Igrese nombre de usuario: " user
read -p "Ingrese contraseña: " pass
read -p "¿Está seguro de estos datos? (y/n): " result

if [ "$result" = "y" ]; then
	echo "Creando usuario..."

	sudo mysql -e "CREATE USER ${user}@'localhost' IDENTIFIED BY '${pass}';"
	sudo mysql -e "CREATE DATABASE db_${user} CHARACTER SET utf8 COLLATE utf8_bin;"
	sudo mysql -e "GRANT ALL PRIVILEGES ON db_${user}.* TO '${user}'@'localhost';"
	sudo mysql -e "FLUSH PRIVILEGES;"

	echo "Usuario creado..."
elif [ "$result" = "n" ]; then
	echo "Saliendo del script"
else
	echo "Respuesta no válida"
fi
