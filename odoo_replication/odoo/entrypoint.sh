#!/bin/bash
OCBDIR=OCB

#Sustituimos las variables de entorno en el odoo.sh
sed -i "s/OCBDIR/$OCBDIR/" /etc/init.d/odoo.sh

#Creamos el archivo de log y cambiamos propietario
mkdir /var/log/odoo
touch /var/log/odoo/odoo.log
chown odoo:odoo /var/log/odoo/odoo.log

#Se conecta a la instancia de postgres indicada en la variable $DBHOST
sed -i "s/db_host = postgres/db_host = $DBHOST/" /opt/odoo/odoo.conf

#Arranca odoo (while: la primera vez no arranca bien)
while [[ ! $(service odoo.sh start) ]];do continue;done

#Uso exec para lanzar un proceso independiente de bucle infinito
exec bash -c "while true;do sleep 10;done"

