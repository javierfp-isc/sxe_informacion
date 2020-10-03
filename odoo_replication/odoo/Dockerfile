FROM javierfpisc/odoo:v13sinpostgres

MAINTAINER javierfp <javierfp@iessanclemente.net>

#Copiamos el entrypoint.sh al container
COPY entrypoint.sh /usr/bin/entrypoint.sh

#Damos permiso al entrypoint
RUN set -x; \
	chmod +x /usr/bin/entrypoint.sh

#Copiamos el archivo odoo.conf
COPY odoo.conf /opt/odoo/odoo.conf

#Comando para arrancar ssh y entrar en bucle de espera
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
