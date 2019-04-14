#!/bin/bash

printf "poner y: "
read result

if [ "$result" = "y" ]; then
	echo "Comenzando instalación..."

elif [ "$result" = "n" ]; then
	echo "No se instalará MySQL 5.7+"
else
	echo "Respuesta no válida"
fi
