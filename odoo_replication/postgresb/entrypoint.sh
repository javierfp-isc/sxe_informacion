#!/bin/bash

#Sale si un comando termina con un valor de retorno diferente a 0
set -e

ODOOUSER=odoo
ODOOPASS=abc123.
MASTERIP=192.168.204.10

#Arrancamos servicios
service ssh start

#Configuración de replicación en el STANDBY (antes de arrancar postgres)
mv /var/lib/postgresql/11/main/ /var/lib/postgresql/11/main.bak
pg_basebackup -h $MASTERIP -U replicator -D /var/lib/postgresql/11/main/ -P --password --slot replicator
chown -R postgres:postgres /var/lib/postgresql/11/main
sed -i "s/#hot_standby = on/hot_standby = on/" /etc/postgresql/11/main/postgresql.conf
echo "standby_mode = 'on'" > /var/lib/postgresql/11/main/recovery.conf
echo "primary_conninfo = 'host=$MASTERIP port=5432 user=replicator password=$ODOOPASS'" >> /var/lib/postgresql/11/main/recovery.conf
echo "primary_slot_name = 'replicator'" >> /var/lib/postgresql/11/main/recovery.conf
echo "trigger_file = '/var/lib/postgresql/11/main/failover.trigger'" >> /var/lib/postgresql/11/main/recovery.conf
chown postgres:postgres /var/lib/postgresql/11/main/recovery.conf

#Arrancamos postgres
service postgresql start

#Uso exec para lanzar un proceso independiente de bucle infinito
exec bash -c "while true;do sleep 10;done"
