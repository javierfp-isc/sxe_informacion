FROM javierfpisc/postgres:v11

#Copiamos el entrypoint.sh al container
COPY entrypoint.sh /usr/bin/entrypoint.sh

#Damos permiso al entrypoint
RUN set -x; \
	chmod +x /usr/bin/entrypoint.sh

#Instalamos apache2 para pgadmin4
RUN set -x; \
        apt update && apt install -y apache2

#Comando para arrancar ssh y entrar en bucle de espera
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
