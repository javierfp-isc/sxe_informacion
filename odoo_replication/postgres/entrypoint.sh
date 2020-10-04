#!/bin/bash

#Sale si un comando termina con un valor de retorno diferente a 0
set -e

ODOOUSER=odoo
ODOOPASS=abc123.
STANDBYIP=192.168.204.20

#Arrancamos servicios
service ssh start

#Arrancamos postgres
service postgresql start

#Crea el usuario odoo en postgres
su - postgres -c "createuser --createdb $ODOOUSER" && su - postgres -c "psql -c \"alter role $ODOOUSER with password '$ODOOPASS'\""

#Configuración de replicación en el MASTER
REPLICATOR=$(su - postgres -c "psql -c \"SELECT rolname FROM pg_catalog.pg_roles WHERE rolname = 'replicator'\"" | grep 0)
if [[ ! $REPLICATOR ]]
then
	su - postgres -c "psql -c \"CREATE ROLE replicator LOGIN REPLICATION ENCRYPTED PASSWORD '$ODOOPASS'\""
	su - postgres -c "psql -c \"SELECT * FROM pg_create_physical_replication_slot('replicator')\""
	echo "host replication replicator $STANDBYIP/32 md5" >> /etc/postgresql/11/main/pg_hba.conf
	service postgresql restart
fi

#Uso exec para lanzar un proceso independiente de bucle infinito
exec bash -c "while true;do sleep 10;done"
