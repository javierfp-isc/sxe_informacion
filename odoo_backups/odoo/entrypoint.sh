#!/bin/bash
ODOOUSER=odoo
ODOOPASS=abc123.
OCBDIR=OCB

#Arrancamos servicios
service postgresql start

#Creamos el archivo de log y cambiamos propietario
mkdir /var/log/odoo
touch /var/log/odoo/odoo.log
chown odoo:odoo /var/log/odoo/odoo.log

#Crea el usuario odoo en postgres
su - postgres -c "createuser --createdb $ODOOUSER" && su - postgres -c "psql -c \"alter role $ODOOUSER with password '$ODOOPASS'\""

#Escribe en /etc/hosts para que resuelva postgres al localhost
echo "127.0.0.1 postgres" >> /etc/hosts

#Sustituimos las variables de entorno en el odoo.sh
sed -i "s/OCBDIR/$OCBDIR/" /etc/init.d/odoo.sh

#Cambiamos propietario del directorio de odoo
[ $(stat -c "%G" $LOCALFS) == "odoo" ] || chown -R odoo:odoo /opt/odoo

#Arranca odoo (while: la primera vez no arranca bien)
while [[ ! $(service odoo.sh start) ]];do continue;done

#Uso exec para lanzar un proceso independiente de bucle infinito
exec bash -c "while true;do sleep 1000;done"

