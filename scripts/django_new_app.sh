#!/bin/bash

read -p "¿Desea crear una nueva app para Django? (y/n): " result

if [ "$result" = "y" ]; then
	
	read -p "Nombre del proyecto: " poject_name
	read -p "Nombre del directorio proyecto: " poject_dir
	read -p "Nombre del directorio proyecto: " poject_dir

	poject_env="${poject_name}env"

	source ~/${poject_dir}/${poject_env}/bin/activate




source ~/desarrollo/desarrolloenv/bin/activate

	echo "Git Instalado"
elif [ "$result" = "n" ]; then
	echo "No se instalaló Git en el sistema"
else
	echo "respuesta no valida"
fi





