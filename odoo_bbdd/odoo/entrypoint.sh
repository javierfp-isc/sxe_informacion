#!/bin/bash

#Arrancamos servicios
service ssh start
service postgresql start

#Creamos el archivo de log y cambiamos propietario
touch /var/log/odoo/odoo.log
chown odoo /var/log/odoo/odoo.log

#Crea el usuario odoo en postgres
su - postgres -c "createuser --createdb $ODOOUSER" && su - postgres -c "psql -c \"alter role $ODOOUSER with password '$ODOOPASS'\""

#Escribe en /etc/hosts para que resuelva postgres al localhost
echo "127.0.0.1 postgres" >> /etc/hosts

#Arranca odoo (while: la primera vez no arranca bien)
while [[ ! $(service odoo.sh start) ]];do continue;done

#Uso exec para lanzar un proceso independiente de bucle infinito
exec bash -c "while true;do sleep 10;done"

