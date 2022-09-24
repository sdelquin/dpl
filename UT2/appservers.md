# Servidores de aplicaciones

Un servidor de aplicaciones es un paquete software que proporciona servicios a las aplicaciones como pueden ser seguridad, servicios de datos, soporte para transacciones, balanceo de carga y gestión de sistemas distribuidos.

El funcionamiento de un servidor de aplicaciones necesita de un servidor web. Muchas veces vienen en el mismo paquete, pero realmente son dos partes diferenciadas.

Cuando un cliente hace una petición al servidor web, este trata de gestionarlo, pero hay muchos elementos con los que no sabe qué hacer. Aquí entra en juego el servidor de aplicaciones, que descarga al servidor web de la gestión de determinados tipos de archivo.

A continuación veremos el despliegue de una aplicación PHP como ejemplo de servidor de aplicaciones.

## PHP nativo

[PHP](https://www.php.net/) es un lenguaje de "scripting" muy enfocado a la programación web (aunque no únicamente) y permite desarrollar aplicaciones integradas en el propio código HTML.

El servidor de aplicación que se utiliza para PHP es [PHP-FPM](https://www.php.net/manual/es/install.fpm.php). Se encarga de manejar los procesos [FastCGI](https://es.wikipedia.org/wiki/FastCGI), un protocolo para interconectar programas interactivos con un servidor web.

Para **instalar PHP-FPM** seguiremos los pasos indicados.

En primer lugar debemos instalar algunos prerrequisitos:

```console
sdelquin@lemon:~$ sudo apt update
sdelquin@lemon:~$ sudo apt install -y lsb-release ca-certificates apt-transport-https software-properties-common gnupg2
...
...
```

Añadimos el repositorio (externo) desde donde descargarnos la última versión de PHP-FPM:

```console
sdelquin@lemon:~$ echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
```

Importamos la clave [GPG](https://es.wikipedia.org/wiki/GNU_Privacy_Guard) del repositorio:

```console
sdelquin@lemon:~$ curl -fsSL  https://packages.sury.org/php/apt.gpg| sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/sury-keyring.gpg
```

Confirmamos que el repositorio está funcionando tras actualizar las fuentes:

```console
sdelquin@lemon:~$ sudo apt update
Obj:1 http://deb.debian.org/debian bullseye InRelease
Obj:2 http://security.debian.org/debian-security bullseye-security InRelease
Obj:3 http://deb.debian.org/debian bullseye-updates InRelease
Obj:4 http://packages.microsoft.com/repos/code stable InRelease
Obj:5 https://packages.sury.org/php bullseye InRelease
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Todos los paquetes están actualizados.
```

Ahora ya podemos instalar PHP-FPM:

```console
sdelquin@lemon:~$ sudo apt install -y php8.1-fpm
...
...
...
```

Dado que PHP-FPM se instala en el sistema como un **servicio**, podemos comprobar su estado utilizando systemd:

```console
sdelquin@lemon:~$ sudo systemctl status php8.1-fpm
● php8.1-fpm.service - The PHP 8.1 FastCGI Process Manager
     Loaded: loaded (/lib/systemd/system/php8.1-fpm.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2022-09-16 11:38:52 WEST; 39min ago
       Docs: man:php-fpm8.1(8)
    Process: 73647 ExecStartPost=/usr/lib/php/php-fpm-socket-helper install /run/php/php-fpm.sock /etc/php/8>
   Main PID: 73644 (php-fpm8.1)
     Status: "Processes active: 0, idle: 2, Requests: 1, slow: 0, Traffic: 0req/sec"
      Tasks: 3 (limit: 2251)
     Memory: 9.4M
        CPU: 181ms
     CGroup: /system.slice/php8.1-fpm.service
             ├─73644 php-fpm: master process (/etc/php/8.1/fpm/php-fpm.conf)
             ├─73645 php-fpm: pool www
             └─73646 php-fpm: pool www

sep 16 11:38:52 lemon systemd[1]: Starting The PHP 8.1 FastCGI Process Manager...
sep 16 11:38:52 lemon systemd[1]: Started The PHP 8.1 FastCGI Process Manager.
```

Con esta instalación, también hemos instalado el propio **intéprete PHP** para ejecutar programas:

```console
sdelquin@lemon:~$ php --version
PHP 8.1.10 (cli) (built: Sep 14 2022 10:31:35) (NTS)
Copyright (c) The PHP Group
Zend Engine v4.1.10, Copyright (c) Zend Technologies
    with Zend OPcache v8.1.10, Copyright (c), by Zend Technologies
```

Podemos probar que funciona bien ejecutando, por ejemplo, una instrucción en PHP que devuelve el nombre de nuestra máquina:

```console
sdelquin@lemon:~$ php -r "echo gethostname();"
lemon
```

### Habilitando PHP en Nginx <!-- omit in TOC -->

Nginx es un servidor web que sirve ficheros pero "no sabe" manejar código escrito en PHP (u otros lenguajes). Es por ello que necesitamos un procesador (servidor de aplicación) como PHP-FPM.

Para habilitar la comunicación entre Nginx y PHP-FPM debemos editar el siguiente fichero de configuración:

```console
sdelquin@lemon:~$ sudo vi /etc/nginx/sites-enabled/default
```

Y modificar lo siguiente:

```nginx
...
...
44         index index.php index.html index.htm index.nginx-debian.html;
...
...
56         location ~ \.php$ {
57                 include snippets/fastcgi-php.conf;
58
59                 # With php-fpm (or other unix sockets):
60                 fastcgi_pass unix:/run/php/php8.1-fpm.sock;
61                 # With php-cgi (or other tcp sockets):
62                 # fastcgi_pass 127.0.0.1:9000;
63         }
...
...
68         location ~ /\.ht {
69                 deny all;
70         }
```

Podemos comprobar que la sintaxis del fichero de configuración es correcta utilizando Nginx:

```console
sdelquin@lemon:~$ sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Ahora recargamos la configuración que hemos modificado:

```console
sdelquin@lemon:~$ sudo systemctl reload nginx
```

### Primera aplicación web en PHP <!-- omit in TOC -->

Creamos un fichero PHP que contendrá un sencillo código mostrando la información de la instalación:

```console
sdelquin@lemon:~$ cd
sdelquin@lemon:~$ mkdir dev
sdelquin@lemon:~$ echo "<?php phpinfo(); ?>" > ~/dev/info.php
```

Ahora enlazamos este fichero desde la carpeta "root" del servidor web Nginx:

```console
sdelquin@lemon:~$ sudo ln -s ~/dev/info.php /var/www/html/
sdelquin@lemon:~$ ls -l /var/www/html/
total 4
-rw-r--r-- 1 root root 612 sep 15 09:26 index.nginx-debian.html
lrwxrwxrwx 1 root root  27 sep 15 12:06 info.php -> /home/sdelquin/dev/info.php
```

Abrimos un navegador en la ruta especificada y vemos el resultado:

```console
sdelquin@lemon:~$ firefox localhost/info.php
```

![PHP info](files/php-info.png)

## PHP dockerizado

Para este escenario es necesario "componer" dos servicios:

- Nginx (`web`)
- PHP-FPM (`php-fpm`)

La estructura del "proyecto" quedaría así:

```console
sdelquin@lemon:~/dev/app$ tree
.
├── default.conf
├── docker-compose.yml
├── fastcgi-php.conf
└── src
    └── index.php

1 directory, 4 files
```

La composición de servicios en Docker se lleva a cabo mediante la herramienta [docker compose](https://docs.docker.com/compose/) usando un fichero de configuración en formato [yaml](https://es.wikipedia.org/wiki/YAML):

```yaml
version: "3.3"

services:
  web:
    image: nginx
    volumes:
      - ./src:/etc/nginx/html
      - ./fastcgi-php.conf:/etc/nginx/fastcgi-php.conf
      - ./default.conf:/etc/nginx/conf.d/default.conf
    ports:
      - 80:80

  php-fpm:
    image: php:8-fpm
    volumes:
      - ./src:/etc/nginx/html
```

Como se puede ver, dependemos de otros dos ficheros de configuración:

**`fastcgi-php.conf`**

```nginx
# regex to split $uri to $fastcgi_script_name and $fastcgi_path
fastcgi_split_path_info ^(.+?\.php)(/.*)$;

# Check that the PHP script exists before passing it
try_files $fastcgi_script_name =404;

# Bypass the fact that try_files resets $fastcgi_path_info
# see: http://trac.nginx.org/nginx/ticket/321
set $path_info $fastcgi_path_info;
fastcgi_param PATH_INFO $path_info;

fastcgi_index index.php;

fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
fastcgi_param PATH_INFO $fastcgi_path_info;
```

**`default.conf`**

```nginx
server {
  server_name _;
  index index.php index.html;

  location ~ \.php$ {
    include fastcgi-php.conf;
    include fastcgi_params;  # fichero incluido en la instalación
    fastcgi_pass php-fpm:9000;
  }
}
```

Y finalmente, nuestro programa PHP de prueba que mostrará por pantalla la configuración misma de PHP:

**`src/index.php`**

```nginx
<?php
  echo phpinfo();
?>
```

Con todo esto ya podemos levantar los servicios:

```console
sdelquin@lemon:~/dev/app$ docker compose up
[+] Running 3/0
 ⠿ Network app_default      Created                                                                                 0.0s
 ⠿ Container app-php-fpm-1  Created                                                                                 0.0s
 ⠿ Container app-web-1      Created                                                                                 0.0s
Attaching to app-php-fpm-1, app-web-1
app-php-fpm-1  | [21-Sep-2022 10:22:20] NOTICE: fpm is running, pid 1
app-php-fpm-1  | [21-Sep-2022 10:22:20] NOTICE: ready to handle connections
app-web-1      | /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
app-web-1      | /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
app-web-1      | /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
app-web-1      | 10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
app-web-1      | 10-listen-on-ipv6-by-default.sh: info: /etc/nginx/conf.d/default.conf differs from the packaged version
app-web-1      | /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
app-web-1      | /docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
app-web-1      | /docker-entrypoint.sh: Configuration complete; ready for start up
app-web-1      | 2022/09/21 10:22:20 [notice] 1#1: using the "epoll" event method
app-web-1      | 2022/09/21 10:22:20 [notice] 1#1: nginx/1.23.1
app-web-1      | 2022/09/21 10:22:20 [notice] 1#1: built by gcc 10.2.1 20210110 (Debian 10.2.1-6)
app-web-1      | 2022/09/21 10:22:20 [notice] 1#1: OS: Linux 5.10.0-18-arm64
app-web-1      | 2022/09/21 10:22:20 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
app-web-1      | 2022/09/21 10:22:20 [notice] 1#1: start worker processes
app-web-1      | 2022/09/21 10:22:20 [notice] 1#1: start worker process 29
app-web-1      | 2022/09/21 10:22:20 [notice] 1#1: start worker process 30
```

Si dejamos este proceso corriendo y abrimos otra pestaña de la terminal, podemos comprobar que la aplicación PHP está funcionando correctamente:

```console
sdelquin@lemon:~/dev/app$ firefox localhost
```

![PHP Info](files/php-info-docker.png)

De hecho podemos también visualizar los servicios que están corriendo dentro de esta "composición", utilizando el siguiente comando:

```console
sdelquin@lemon:~/dev/app$ docker compose ps
NAME                COMMAND                  SERVICE             STATUS              PORTS
app-php-fpm-1       "docker-php-entrypoi…"   php-fpm             running             9000/tcp
app-web-1           "/docker-entrypoint.…"   web                 running             0.0.0.0:80->80/tcp, :::80->80/tcp
```
