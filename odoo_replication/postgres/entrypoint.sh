#!/bin/bash
ODOOUSER=odoo
ODOOPASS=abc123.

#Habilitar acceso desde host remotos
[[ $(grep "^host all all 0.0.0.0/0 md5" /etc/postgresql/13/main/pg_hba.conf) ]] || echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/13/main/pg_hba.conf
[[ $(grep "^listen_addresses='*'" /etc/postgresql/13/main/postgresql.conf) ]] || echo "listen_addresses='*'" >> /etc/postgresql/13/main/postgresql.conf

#Arrancamos postgres
service postgresql start

#Crea el usuario odoo en postgres
su - postgres -c "createuser --createdb $ODOOUSER" && su - postgres -c "psql -c \"alter role $ODOOUSER with password '$ODOOPASS'\""

#Uso exec para lanzar un proceso independiente de bucle infinito
exec bash -c "while true;do sleep 10;done"
