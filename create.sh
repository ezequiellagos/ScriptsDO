#!/bin/bash

# Descripción: Permite crear un nuevo script vacio añadiendole los permisos de ejecución

printf "Ingrese nombre del script: "
read file

cat > $file << EOF
#!/bin/bash



EOF

sudo chmod +x $file

echo "Script $file creado"
