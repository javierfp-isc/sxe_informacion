FROM debian:buster

MAINTAINER javierfp <javierfp@iessanclemente.net>

ENV TERM xterm
ENV PASS=abc123.
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV NETWORK=192.168.203.0/24

LABEL distribucion="Debian 10"
LABEL descripcion="Imagen Postgres base Odoo 13  para prácticas"
LABEL paquetes="vim, curl, wget, iputils-ping, net-tools, nano, openssh-server"
LABEL acceso="usuario: root, password: abc123."

#Copiamos el entrypoint.sh al container
COPY entrypoint.sh /usr/bin/entrypoint.sh

#Damos permiso al entrypoint
RUN set -x; \
	chmod +x /usr/bin/entrypoint.sh

#Establecemos la password de root
RUN set -x; \
	echo "root:$PASS" | chpasswd

#Instalamos paquetes de utilidades
RUN set -x; \
	apt update && apt install -y vim curl wget iputils-ping net-tools nano openssh-server 

#Configuramos openssh-server para poder acceder con root
RUN set -x; \
	echo "PermitRootLogin yes\nPasswordAuthentication yes" >> /etc/ssh/sshd_config

#Instalamos postgresql
RUN set -x; \
	apt install -y postgresql

#Instalamos apache2 para pgadmin4
RUN set -x; \
	apt install -y apache2

#Configuramos acceso a postgresql
RUN set -x; \
	echo "listen_addresses = '*'" >> /etc/postgresql/11/main/postgresql.conf && \
	echo "host all all $NETWORK md5" >> /etc/postgresql/11/main/pg_hba.conf

#Limpiando
RUN set -x; \
	apt clean

#Comando para arrancar ssh y entrar en bucle de espera
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
