#!/bin/bash

#Sale si un comando termina con un valor de retorno diferente a 0
set -e

ODOOUSER=odoo
ODOOPASS=abc123.

#Arrancamos servicios
service ssh start
service postgresql start
service apache2 start

#Crea el usuario odoo en postgres
su - postgres -c "createuser --createdb $ODOOUSER" && su - postgres -c "psql -c \"alter role $ODOOUSER with password '$ODOOPASS'\""

#Uso exec para lanzar un proceso independiente de bucle infinito
exec bash -c "while true;do sleep 10;done"

