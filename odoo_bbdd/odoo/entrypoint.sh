#!/bin/bash
OCBDIR=OCB16

#Creamos el archivo de log y cambiamos propietario
mkdir /var/log/odoo
touch /var/log/odoo/odoo.log
chown odoo:odoo /var/log/odoo/odoo.log

#Sustituimos las variables de entorno en el odoo.sh
sed -i "s/OCBDIR/$OCBDIR/" /etc/init.d/odoo.sh

#Cambiamos propietario del directorio de odoo
[ $(stat -c "%G" $LOCALFS) == "odoo" ] || chown -R odoo:odoo /opt/odoo

#Arranca odoo (while: la primera vez no arranca bien)
while [[ ! $(service odoo.sh start) ]];do continue;done

#Uso exec para lanzar un proceso independiente de bucle infinito
exec bash -c "while true;do sleep 10;done"

