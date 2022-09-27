# Instalación y configuración básica de un servidor web

![Nginx Logo](files/nginx-logo.png)

**Nginx** se define como un **servidor web** / **proxy inverso** ligero de alto rendimiento.

![Arquitectura Nginx](./images/nginx-arquitecture.png)

Vamos a optar por instalar Nginx sobre un sistema operativo **Linux**, una de las opciones más extendidas con la posibilidad de obtener este software de manera gratuita. Nginx destaca sobre otros servidores porque:

- Tiene un diseño modular y altamente configurable.
- Ofrece un alto rendimiento.
- Es de código abierto por lo que existen muchas extensiones y herramientas de terceros.
- Forma parte de muchos "stacks" tecnológicos modernos.
- Existen versiones para muchos sistemas operativos incluyendo Windows, Linux y MacOS.

Lo más "habitual" sería instalar Nginx en un sistema operativo de tipo servidor pero por motivos didácticos, vamos a instalarlo en una versión estándar con interfaz gráfica. Es menos seguro por lo que en un sistema en producción deberíamos optar por la otra opción. A pesar de usar un Linux con interfaz gráfica vamos a instalar todo desde la ventana de terminal, por lo que los pasos se podrán aplicar a un servidor.

## Instalación nativa

Lo primero será actualizar el listado de paquetes:

```console
sdelquin@lemon:~$ sudo apt update
Des:1 http://security.debian.org/debian-security bullseye-security InRelease [48,4 kB]
Obj:2 http://deb.debian.org/debian bullseye InRelease
Des:3 http://deb.debian.org/debian bullseye-updates InRelease [44,1 kB]
Des:4 http://security.debian.org/debian-security bullseye-security/main Sources [152 kB]
Des:5 http://packages.microsoft.com/repos/code stable InRelease [10,4 kB]
Des:6 http://security.debian.org/debian-security bullseye-security/main arm64 Packages [181 kB]
Des:7 http://security.debian.org/debian-security bullseye-security/main Translation-en [115 kB]
Des:8 http://packages.microsoft.com/repos/code stable/main arm64 Packages [109 kB]
Des:9 http://packages.microsoft.com/repos/code stable/main armhf Packages [109 kB]
Des:10 http://packages.microsoft.com/repos/code stable/main amd64 Packages [108 kB]
Descargados 878 kB en 1s (1.324 kB/s)
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Todos los paquetes están actualizados.
```

A continuación instalaremos el paquete `nginx`:

```console
sdelquin@lemon:~$ sudo apt install -y nginx
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Se instalarán los siguientes paquetes adicionales:
  geoip-database libgeoip1 libnginx-mod-http-geoip
  libnginx-mod-http-image-filter libnginx-mod-http-xslt-filter
  libnginx-mod-mail libnginx-mod-stream libnginx-mod-stream-geoip nginx-common
  nginx-core
Paquetes sugeridos:
  geoip-bin fcgiwrap nginx-doc
Se instalarán los siguientes paquetes NUEVOS:
  geoip-database libgeoip1 libnginx-mod-http-geoip
  libnginx-mod-http-image-filter libnginx-mod-http-xslt-filter
  libnginx-mod-mail libnginx-mod-stream libnginx-mod-stream-geoip nginx
  nginx-common nginx-core
0 actualizados, 11 nuevos se instalarán, 0 para eliminar y 0 no actualizados.
Se necesita descargar 4.507 kB de archivos.
Se utilizarán 13,3 MB de espacio de disco adicional después de esta operación.
Des:1 http://deb.debian.org/debian bullseye/main arm64 geoip-database all 20191224-3 [3.032 kB]
Des:2 http://deb.debian.org/debian bullseye/main arm64 libgeoip1 arm64 1.6.12-7 [90,7 kB]
Des:3 http://deb.debian.org/debian bullseye/main arm64 nginx-common all 1.18.0-6.1+deb11u2 [126 kB]
Des:4 http://deb.debian.org/debian bullseye/main arm64 libnginx-mod-http-geoip arm64 1.18.0-6.1+deb11u2 [98,2 kB]
Des:5 http://deb.debian.org/debian bullseye/main arm64 libnginx-mod-http-image-filter arm64 1.18.0-6.1+deb11u2 [102 kB]
Des:6 http://deb.debian.org/debian bullseye/main arm64 libnginx-mod-http-xslt-filter arm64 1.18.0-6.1+deb11u2 [100 kB]
Des:7 http://deb.debian.org/debian bullseye/main arm64 libnginx-mod-mail arm64 1.18.0-6.1+deb11u2 [127 kB]
Des:8 http://deb.debian.org/debian bullseye/main arm64 libnginx-mod-stream arm64 1.18.0-6.1+deb11u2 [151 kB]
Des:9 http://deb.debian.org/debian bullseye/main arm64 libnginx-mod-stream-geoip arm64 1.18.0-6.1+deb11u2 [97,4 kB]
Des:10 http://deb.debian.org/debian bullseye/main arm64 nginx-core arm64 1.18.0-6.1+deb11u2 [490 kB]
Des:11 http://deb.debian.org/debian bullseye/main arm64 nginx all 1.18.0-6.1+deb11u2 [92,9 kB]
Descargados 4.507 kB en 0s (9.951 kB/s)
Preconfigurando paquetes ...
Seleccionando el paquete geoip-database previamente no seleccionado.
(Leyendo la base de datos ... 220164 ficheros o directorios instalados actualmen
te.)
Preparando para desempaquetar .../00-geoip-database_20191224-3_all.deb ...
Desempaquetando geoip-database (20191224-3) ...
Seleccionando el paquete libgeoip1:arm64 previamente no seleccionado.
Preparando para desempaquetar .../01-libgeoip1_1.6.12-7_arm64.deb ...
Desempaquetando libgeoip1:arm64 (1.6.12-7) ...
Seleccionando el paquete nginx-common previamente no seleccionado.
Preparando para desempaquetar .../02-nginx-common_1.18.0-6.1+deb11u2_all.deb ...
Desempaquetando nginx-common (1.18.0-6.1+deb11u2) ...
Seleccionando el paquete libnginx-mod-http-geoip previamente no seleccionado.
Preparando para desempaquetar .../03-libnginx-mod-http-geoip_1.18.0-6.1+deb11u2_
arm64.deb ...
Desempaquetando libnginx-mod-http-geoip (1.18.0-6.1+deb11u2) ...
Seleccionando el paquete libnginx-mod-http-image-filter previamente no seleccion
ado.
Preparando para desempaquetar .../04-libnginx-mod-http-image-filter_1.18.0-6.1+d
eb11u2_arm64.deb ...
Desempaquetando libnginx-mod-http-image-filter (1.18.0-6.1+deb11u2) ...
Seleccionando el paquete libnginx-mod-http-xslt-filter previamente no selecciona
do.
Preparando para desempaquetar .../05-libnginx-mod-http-xslt-filter_1.18.0-6.1+de
b11u2_arm64.deb ...
Desempaquetando libnginx-mod-http-xslt-filter (1.18.0-6.1+deb11u2) ...
Seleccionando el paquete libnginx-mod-mail previamente no seleccionado.
Preparando para desempaquetar .../06-libnginx-mod-mail_1.18.0-6.1+deb11u2_arm64.
deb ...
Desempaquetando libnginx-mod-mail (1.18.0-6.1+deb11u2) ...
Seleccionando el paquete libnginx-mod-stream previamente no seleccionado.
Preparando para desempaquetar .../07-libnginx-mod-stream_1.18.0-6.1+deb11u2_arm6
4.deb ...
Desempaquetando libnginx-mod-stream (1.18.0-6.1+deb11u2) ...
Seleccionando el paquete libnginx-mod-stream-geoip previamente no seleccionado.
Preparando para desempaquetar .../08-libnginx-mod-stream-geoip_1.18.0-6.1+deb11u
2_arm64.deb ...
Desempaquetando libnginx-mod-stream-geoip (1.18.0-6.1+deb11u2) ...
Seleccionando el paquete nginx-core previamente no seleccionado.
Preparando para desempaquetar .../09-nginx-core_1.18.0-6.1+deb11u2_arm64.deb ...
Desempaquetando nginx-core (1.18.0-6.1+deb11u2) ...
Seleccionando el paquete nginx previamente no seleccionado.
Preparando para desempaquetar .../10-nginx_1.18.0-6.1+deb11u2_all.deb ...
Desempaquetando nginx (1.18.0-6.1+deb11u2) ...
Configurando nginx-common (1.18.0-6.1+deb11u2) ...
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /lib
/systemd/system/nginx.service.
Configurando libnginx-mod-http-xslt-filter (1.18.0-6.1+deb11u2) ...
Configurando libgeoip1:arm64 (1.6.12-7) ...
Configurando geoip-database (20191224-3) ...
Configurando libnginx-mod-mail (1.18.0-6.1+deb11u2) ...
Configurando libnginx-mod-http-image-filter (1.18.0-6.1+deb11u2) ...
Configurando libnginx-mod-stream (1.18.0-6.1+deb11u2) ...
Configurando libnginx-mod-stream-geoip (1.18.0-6.1+deb11u2) ...
Configurando libnginx-mod-http-geoip (1.18.0-6.1+deb11u2) ...
Configurando nginx-core (1.18.0-6.1+deb11u2) ...
Upgrading binary: nginx.
Configurando nginx (1.18.0-6.1+deb11u2) ...
Procesando disparadores para man-db (2.9.4-2) ...
Procesando disparadores para libc-bin (2.31-13+deb11u4) ...
```

Con esto, en principio, ya debería estar instalado el servidor web **Nginx**. Para obtener las características de la versión instalada, podemos ejecutar:

```console
sdelquin@lemon:~$ sudo nginx -V
nginx version: nginx/1.18.0
built with OpenSSL 1.1.1n  15 Mar 2022
TLS SNI support enabled
configure arguments: --with-cc-opt='-g -O2 -ffile-prefix-map=/build/nginx-vNp64q/nginx-1.18.0=. -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -fPIC' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-compat --with-debug --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_sub_module
```

Igualmente podemos comprobar que el servicio está corriendo correctamente mediante [systemd](https://wiki.debian.org/systemd):

```console
sdelquin@lemon:~$ sudo systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2022-09-15 09:26:18 WEST; 6min ago
       Docs: man:nginx(8)
    Process: 6233 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/>
    Process: 6234 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 6316 (nginx)
      Tasks: 3 (limit: 2251)
     Memory: 3.9M
        CPU: 14ms
     CGroup: /system.slice/nginx.service
             ├─6316 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             ├─6319 nginx: worker process
             └─6320 nginx: worker process

sep 15 09:26:18 lemon systemd[1]: Starting A high performance web server and a reverse proxy server...
sep 15 09:26:18 lemon systemd[1]: Started A high performance web server and a reverse proxy server.
```

Para comprobar nuestra instalación de **Nginx**, accedemos a http://localhost:

```console
sdelquin@lemon:~$ firefox localhost
```

![Nginx Hello](files/nginx-hello.png)

Del mismo modo podremos acceder a http://127.0.0.1 (ip para localhost):

```console
sdelquin@lemon:~$ firefox 127.0.0.1
```

![Nginx Hello 127](files/nginx-hello-127.png)

> Dado que Nginx se instala como servicio, ya queda configurado para autoarrancarse. Eso significa que si reiniciamos el equipo, podemos comprobar que el servidor web volverá a levantarse tras cada arranque.

## Instalación dockerizada

[Docker](https://www.docker.com/) es un proyecto de código abierto que automatiza el despliegue de aplicaciones dentro de contenedores de software, proporcionando una capa adicional de abstracción y automatización de virtualización de aplicaciones en múltiples sistemas operativos.​

→ [Iniciación a Docker](./docker.md)

Existen multitud de imágenes para contenedores ya preparadas en [Docker Hub](https://hub.docker.com/search). Una de ellas es [Nginx](https://hub.docker.com/_/nginx). Lanzar este contenedor es bastante sencillo:

```console
sdelquin@lemon:~$ docker run -p 80:80 nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
3d898485473e: Pull complete
3f45c0a5377f: Pull complete
f1cdcf23708a: Pull complete
a73e5a7988e9: Pull complete
43509f6ae4b3: Pull complete
8460b172ee88: Pull complete
Digest: sha256:0b970013351304af46f322da1263516b188318682b2ab1091862497591189ff1
Status: Downloaded newer image for nginx:latest
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2022/09/19 08:16:45 [notice] 1#1: using the "epoll" event method
2022/09/19 08:16:45 [notice] 1#1: nginx/1.23.1
2022/09/19 08:16:45 [notice] 1#1: built by gcc 10.2.1 20210110 (Debian 10.2.1-6)
2022/09/19 08:16:45 [notice] 1#1: OS: Linux 5.10.0-18-arm64
2022/09/19 08:16:45 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2022/09/19 08:16:45 [notice] 1#1: start worker processes
2022/09/19 08:16:45 [notice] 1#1: start worker process 31
2022/09/19 08:16:45 [notice] 1#1: start worker process 32
2022/09/19 08:18:39 [notice] 1#1: signal 28 (SIGWINCH) received
```

> Con `-p 80:80` estamos mapeando el puerto 80 de la máquina anfitriona ("host") al puerto 80 del contenedor Docker.

> ⭐ `-p <puerto-máquina-anfitriona>:<puerto-contenedor-Docker>`

Si dejamos este proceso corriendo y abrimos una nueva pestaña, podemos lanzar un navegador web en http://localhost y comprobar que el servidor web está instalado y funcionando:

```console
sdelquin@lemon:~$ firefox localhost
```

![Nginx Hello](files/nginx-hello.png)

> Podemos parar el contenedor simplemente pulsando <kbd>Ctrl-C</kbd>.

Correr un contenedor implica descargar su imagen (si es que no existía). Este proceso denominado "pull" hace que dispongamos de la imagen del contenedor de manera permanente (hasta que se elimine) en nuestro disco.

Podemos ver las imágenes descargadas de la siguiente manera:

```console
sdelquin@lemon:~$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
nginx         latest    0c404972e130   5 days ago     135MB
hello-world   latest    46331d942d63   6 months ago   9.14kB
```
