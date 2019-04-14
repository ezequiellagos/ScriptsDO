#!/bin/bash

# Referencia
# https://www.digitalocean.com/community/tutorials/how-to-set-up-django-with-postgres-nginx-and-gunicorn-on-ubuntu-18-04#creating-systemd-socket-and-service-files-for-gunicorn

read -p "¿Desea configurar Django con Postgres, Nginx, Gunicorn y Python 3? (y/n): " result

if [ "$result" = "y" ]; then
	echo "Comenzando instalación..."

	sudo apt update
	sudo apt -y install python3-pip python3-dev libpq-dev postgresql postgresql-contrib nginx curl

	# Variables Base
	read -p "Nombre del proyecto: " poject_name
	read -p "Nombre del directorio proyecto: " poject_dir
	read -p "Nombre del usuario de la base de datos: " db_user
	read -p "Contraseña del usuario de la base de datos: " db_pass
	read -p "URL del proyecto (ej: proyecto.cl): " url
	
	db_name="db_${poject_name}"
	poject_env="${poject_name}env"
	system_user=$(whoami)
	ipv4=$(curl ifconfig.me)
	ALLOWED_HOSTS="ALLOWED_HOSTS = ['localhost', '${ipv4}', '${url}']"

	# Postgress	
	sudo -u postgres psql -c "CREATE DATABASE ${db_name};"
	sudo -u postgres psql -c "CREATE USER ${db_user} WITH PASSWORD '${db_pass}';"
	sudo -u postgres psql -c "ALTER ROLE ${db_user} SET client_encoding TO 'utf8';"
	sudo -u postgres psql -c "ALTER ROLE ${db_user} SET default_transaction_isolation TO 'read committed';"
	sudo -u postgres psql -c "ALTER ROLE ${db_user} SET timezone TO 'UTC';"
	sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ${db_name} TO ${db_user};"

	# Virtualenv
	sudo -H pip3 install --upgrade pip
	sudo -H pip3 install virtualenv
	mkdir ~/${poject_dir}
	cd ~/${poject_dir}
	virtualenv ${poject_env}
	source ${poject_env}/bin/activate
	pip install django gunicorn psycopg2-binary

	# Config Django
	django-admin.py startproject ${poject_name} ~/${poject_dir}
	sed -i "s/ALLOWED_HOSTS =.*/${ALLOWED_HOSTS}/g" ~/${poject_dir}/${poject_name}/settings.py
	echo "Reemplace el siguiente código en ~/${poject_dir}/${poject_name}/settings.py"
	printf "____START____\nDATABASES = {\n    'default': {\n        'ENGINE': 'django.db.backends.postgresql_psycopg2',\n        'NAME': '${db_name}',\n        'USER': '${db_user}',\n        'PASSWORD': '${db_pass}',\n        'HOST': 'localhost',\n        'PORT': '',\n    }\n}\n____FINISH____\n"
	read -p "Presionar cualquier tecla despues de copiar el texto anterior: " flag_help
	sudo nano ~/${poject_dir}/${poject_name}/settings.py
	echo "STATIC_ROOT = os.path.join(BASE_DIR, 'static/')" >> ~/${poject_dir}/${poject_name}/settings.py

	python ~/${poject_dir}/manage.py makemigrations
	python ~/${poject_dir}/manage.py migrate
	python ~/${poject_dir}/manage.py createsuperuser
	python ~/${poject_dir}/manage.py collectstatic

	cd ~/${poject_dir}
	deactivate

	# Gunicorn Socket and Service
	sudo touch /etc/systemd/system/gunicorn.socket
	printf "[Unit]\nDescription=gunicorn socket\n\n[Socket]\nListenStream=/run/gunicorn.sock\n\n[Install]\nWantedBy=sockets.target\n\n" | sudo tee /etc/systemd/system/gunicorn.socket
	sudo touch /etc/systemd/system/gunicorn.service
	printf "[Unit]\nDescription=gunicorn daemon\nRequires=gunicorn.socket\nAfter=network.target\n\n[Service]\nUser=${system_user}\nGroup=www-data\nWorkingDirectory=/home/${system_user}/${poject_dir}\nExecStart=/home/${system_user}/${poject_dir}/${poject_env}/bin/gunicorn --access-logfile - --workers 3 --bind unix:/run/gunicorn.sock ${poject_name}.wsgi:application\n\n[Install]\nWantedBy=multi-user.target\n\n" | sudo tee /etc/systemd/system/gunicorn.service

	sudo systemctl daemon-reload
	sudo systemctl start gunicorn.socket
	sudo systemctl enable gunicorn.socket
	sudo systemctl status gunicorn.socket

	# Nginx
	sudo touch /etc/nginx/sites-available/${poject_name}
	printf "server { \n    listen 80;\n    server_name ${url};\n\n    location = /favicon.ico { access_log off; log_not_found off; }\n    location /static/ {\n        root /home/${system_user}/${poject_dir};\n    }\n\n    location / {\n        include proxy_params;\n        proxy_pass http://unix:/run/gunicorn.sock;\n    }\n}\n\n" | sudo tee /etc/nginx/sites-available/${poject_name}
	sudo ln -s /etc/nginx/sites-available/${poject_name} /etc/nginx/sites-enabled
	sudo nginx -t
	sudo systemctl restart nginx
	sudo ufw allow 'Nginx Full'

	# Reload
	sudo systemctl start postgresql
	sudo systemctl enable postgresql
	sudo systemctl restart gunicorn
	sudo systemctl daemon-reload
	sudo systemctl restart gunicorn.socket gunicorn.service
	sudo nginx -t && sudo systemctl restart nginx
elif [ "$result" = "n" ]; then
	echo "No se configurará Django con Postgres, Nginx, Gunicorn y Python 3"
else
	echo "Respuesta no válida"
fi
