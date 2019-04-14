#!/bin/bash

read -p "¿Desea crear una partición Swap? (y/n): " result

if [ "$result" = "y" ]; then

	printf "Ingrese un numero en GB para la partición: "
	read size_swap

	sudo fallocate -l ${size_swap}G /swapfile
	sudo chmod 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile
	sudo sysctl vm.swappiness=10
	sudo sysctl vm.vfs_cache_pressure=50

	printf "¿Desea hacer permanente la partición Swap? (y/n): "
	read permanent_swap
	if [ "$permanent_swap" = "y" ]; then

		sudo cp /etc/fstab /etc/fstab.bak
		echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
		echo "vm.swappiness=10" >> /etc/sysctl.conf
		echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf
		
		echo "Se hizo permanente la partición Swap"
	elif [ "$permanent_swap" = "n" ]; then
		echo "No se hizo permanente la partición Swap"
	else
		echo "respuesta no valida"
		exit 1
	fi
	
	echo "Partición Swap de ${size_swap}GB ha sido creada"
elif [ "$result" = "n" ]; then
	echo "No se ha creado la partición Swap"
else
	echo "respuesta no valida"
fi
