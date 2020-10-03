#!/bin/bash

#Arrancamos servicios
service ssh start

#Creamos el archivo de log y cambiamos propietario
touch /var/log/odoo/odoo.log
chown odoo /var/log/odoo/odoo.log

#Se conecta a la instancia de postgres indicada en la variable $DBHOST
sed -i "s/db_host = postgres/db_host = $DBHOST/" /opt/odoo/odoo.conf

#Arranca odoo (while: la primera vez no arranca bien)
while [[ ! $(service odoo.sh start) ]];do continue;done

#Uso exec para lanzar un proceso independiente de bucle infinito
exec bash -c "while true;do sleep 10;done"

