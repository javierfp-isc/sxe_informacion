#!/bin/bash

#Sale si un comando termina con un valor de retorno diferente a 0
set -e

ODOOUSER=odoo
ODOOPASS=abc123.

#Arrancamos servicios
service ssh start
service postgresql start

#Ejecutamos en el MASTER
if [ $ROLE = MASTER ]
then
	su - postgres -c "psql -c \"CREATE ROLE replicator LOGIN REPLICATION ENCRYPTED PASSWORD '$ODOOPASS'\""
	su - postgres -c "psql -c \"SELECT * FROM pg_create_physical_replication_slot('replicator')\""
	echo "host replication replicator 192.168.204.20/32 md5" >> /etc/postgresql/11/main/pg_hba.conf
	service postgresql restart
fi

#Ejecutamos en el STANDBY
if [ $ROLE = STANDBY ]
then
	service postgresql stop
	sleep 5
	mv /var/lib/postgresql/11/main/ /var/lib/postgresql/11/main.bak
	pg_basebackup -h 192.168.204.10 -U replicator -D /var/lib/postgresql/11/main/ -P --$ODOOPASS --slot replicator
	chown -R postgres:postgres /var/lib/postgresql/11/main
	sed -i "s/#hot_standby = on/hot_standby = on/" /etc/postgresql/11/main/postgresql.conf
	echo "standby_mode = 'on'" > /var/lib/postgresql/11/main/recovery.conf
	echo "primary_conninfo = 'host=192.168.204.10 port=5432 user=replicator password=$ODOOPASS'" >> /var/lib/postgresql/11/main/recovery.conf
	echo "primary_slot_name = 'replicator'" >> /var/lib/postgresql/11/main/recovery.conf
	echo "trigger_file = '/var/lib/postgresql/11/main/failover.trigger'" >> /var/lib/postgresql/11/main/recovery.conf
	chown postgres:postgres /var/lib/postgresql/11/main/recovery.conf
	service postgresql start
fi

#Crea el usuario odoo en postgres
su - postgres -c "createuser --createdb $ODOOUSER" && su - postgres -c "psql -c \"alter role $ODOOUSER with password '$ODOOPASS'\""

#Uso exec para lanzar un proceso independiente de bucle infinito
exec bash -c "while true;do sleep 10;done"

