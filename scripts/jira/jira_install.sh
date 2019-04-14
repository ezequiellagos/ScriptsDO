#!/bin/bash

url="https://product-Downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-8.0.0-x64.bin"
file_url=${url##*/}

# Mirar para más información sobre la url https://confluence.atlassian.com/doc/database-jdbc-drivers-171742.html
url_mysql_driver="https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz"
file_mysql_driver=${url_mysql_driver##*/}
file_jar_mysql_driver=${file_mysql_driver/.tar.gz/-bin.jar}
folder_mysql_driver=${file_mysql_driver/.tar.gz/}

printf "¿Instalar Jira Software? (y/n): "
read result

if [ "$result" = "y" ]; then
	echo "Comenzando instalación..."

		printf "¿Instalar Driver MySQL? (y/n): "
		read result_mysql
		if [ "$result_mysql" = "y" ]; then
			echo "Instalando Driver MySQL..."

			echo "Descargando $url_mysql_driver"
			wget $url_mysql_driver
			tar -xzvf $file_mysql_driver $folder_mysql_driver/$file_jar_mysql_driver
			cd $folder_mysql_driver/
			sudo mv $file_jar_mysql_driver /opt/atlassian/jira/lib/
			cd ..
			sudo rm -r $folder_mysql_driver/
			sudo rm $file_mysql_driver

		elif [ "$result_mysql" = "n" ]; then
			echo "No se instalará el Driver de MySQL"
		else
			echo "Respuesta no válida. Saliendo del Script"
			exit 1
		fi

	echo "Instalando Jira Software..."
	echo "Descargando $url"
	wget $url
	chmod a+x $file_url
	sudo ./$file_url
	sudo rm $file_url

elif [ "$result" = "n" ]; then
	echo "No se instalará Jira Software"
else
	echo "Respuesta no válida"
fi
