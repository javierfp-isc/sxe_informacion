FROM debian:buster

MAINTAINER javierfp <javierfp@iessanclemente.net>

ENV TERM xterm
ENV ODOOUSER=odoo
ENV ODOOPASS=abc123.
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

LABEL distribucion="Debian 10"
LABEL descripcion="Imagen Odoo para prácticas"
LABEL paquetes="vim, git, curl, iputils-ping, net-tools, nano, wget, openssh-server"
LABEL acceso="usuario: root, password: abc123."

#Copiamos el entrypoint.sh al container
COPY entrypoint.sh /usr/bin/entrypoint.sh

#Copiamos el script de odoo
COPY odoo.sh /etc/init.d/odoo.sh

#Activamos el script (set -x muestra la salida de todos los comandos)
RUN set -x; \  
	chmod +x /etc/init.d/odoo.sh

#Damos permiso al entrypoint
RUN set -x; \
	chmod +x /usr/bin/entrypoint.sh

#Establecemos la password de root
RUN set -x; \
	echo "root:$ODOOPASS" | chpasswd

#Crea el usuario para odoo
RUN set -x; \
	useradd -m -d /opt/$ODOOUSER -U -s /bin/bash $ODOOUSER && echo "$ODOOUSER:$ODOOPASS" | chpasswd

#Copiamos el odoo.conf al container
COPY odoo.conf /opt/$ODOOUSER/odoo.conf

#Instalamos paquetes de utilidades
RUN set -x; \
	apt update && apt install -y vim git curl iputils-ping net-tools nano wget openssh-server 

#Configuramos openssh-server para poder acceder con root
RUN set -x; \
	echo "PermitRootLogin yes\nPasswordAuthentication yes" >> /etc/ssh/sshd_config

#Instalamos paquetes de base para odoo
RUN set -x; \
	apt install -y python3 postgresql virtualenv build-essential python3-dev python3-pip libxslt-dev libsasl2-dev libssl-dev libldap2-dev libzip-dev

#wkhtmltopdf
RUN set -x; \
	cd /tmp \
	wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb -O wkhtmltox_0.12.5-1.buster_amd64.deb \
	apt install -y /tmp/wkhtmltox_0.12.5-1.buster_amd64.deb

#Descargando archivo requirements para odoo
RUN set -x; \
	wget https://raw.githubusercontent.com/OCA/OCB/13.0/requirements.txt -O /tmp/requirements.txt

#Instalando paquetes python para odoo
RUN set -x; \
	pip3 install -r /tmp/requirements.txt

#Limpiando
RUN set -x; \
	apt clean

#Comando para arrancar ssh y entrar en bucle de espera
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
