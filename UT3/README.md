# UT3: Administración de servidores web

Ya hemos visto la instalación de Nginx. En esta unidad de trabajo nos vamos a dedicar a explorar todas sus opciones de configuración y administración.

[Configuración del servidor web](#configuración-del-servidor-web)  
[Hosts virtuales](#hosts-virtuales)  
[Directivas](#directivas)  
[Módulos](#módulos)

## Configuración del servidor web

En Nginx, la configuración del servicio está en el archivo `/etc/nginx/nginx.conf` con el siguiente contenido:

```nginx
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
```

### Número de conexiones

- [worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes) establece el número de procesos que atienden peticiones. El valor por defecto "auto" indica que se usarán todos los _cores_ disponibles.
- [worker_connections](https://nginx.org/en/docs/ngx_core_module.html#worker_connections) establece el número simultáneo de conexiones que puede atender un _worker_. El valor por defecto es 1024.

Por lo tanto, el número máximo de clientes viene dado por:

```
max_clients = worker_processes * worker_connections
```

Vamos a comprobar el estado de los _workers_ de Nginx:

```console
sdelquin@lemon:~$ sudo systemctl status nginx | grep nginx:
             ├─176437 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             ├─176438 nginx: worker process
             └─176439 nginx: worker process
```

Se puede ver que hay un proceso _master_ y dos _workers_. Esto se visualiza aún mejor mostrando un árbol de procesos:

```console
sdelquin@lemon:~$ pstree -p 176437
nginx(176437)─┬─nginx(176438)
              └─nginx(176439)
```

El hecho de que hayan 2 _workers_ es debido a que la máquina dispone de 2 _cores_ tal y como se indica a continuación:

```console
sdelquin@lemon:~$ nproc
2
```

¿Cuál es el valor máximo que puedo establecer en Nginx para número de conexiones del _worker_? Para responder a esta pregunta basta con ejecutar el comando siguiente:

```console
sdelquin@lemon:~$ ulimit -n
1024
```

Desde la ayuda de la shell (`man bash`) podemos extraer información sobre el comando `ulimit` y sus parámetros:

```console
-n: The maximum number of open file descriptors (most systems do not allow this value to be set)
```

### Usuario de trabajo

El **usuario** con el que Nginx accede al sistema es `nginx`, tal y como se puede comprobar al listar los procesos:

```console
sdelquin@lemon:~$ ps aux | grep nginx | grep worker
nginx     192386  0.0  0.1   9904  3760 ?        S    01:33   0:00 nginx: worker process
nginx     192387  0.0  0.1   9904  3760 ?        S    01:33   0:00 nginx: worker process
```

> Es importante tenerlo en cuenta de cara a los permisos que asignemos a ficheros y carpetas.

### Carpeta raíz

Un concepto fundamental en los servidores web es el de `root` que indica la carpeta raíz desde la que se sirven los archivos.

El valor por defecto que tiene `root` en Nginx es `/etc/nginx/html` y eso viene dado por el parámetro `--prefix` (junto a `html`) durante la fase de compilación:

```console
sdelquin@lemon:~$ sudo nginx -V
nginx version: nginx/1.22.0
built by gcc 10.2.1 20210110 (Debian 10.2.1-6)
built with OpenSSL 1.1.1k  25 Mar 2021 (running with OpenSSL 1.1.1n  15 Mar 2022)
TLS SNI support enabled
configure arguments: (...) --prefix=/etc/nginx (...)
```

Sin embargo, este comportamiento se puede modificar si establecemos un valor distinto para `root` en el _virtual-host_.

## Hosts virtuales

Nginx se configura a través de bloques de servidor denominados _**virtual hosts**_. Cada uno de ellos nos permite montar un servicio diferente.

La definición de los _virtual host_ se lleva a cabo mediante un fichero `*.conf` presente en la ruta `/etc/nginx/conf.d/`

> Esta ruta viene definida mediante un `include` en el fichero de configuración `nginx.conf`

### Sitio por defecto

La propia instalación de Nginx ya configura un _virtual host_ **por defecto**. Destacamos algunas líneas de este fichero `/etc/nginx/conf.d/default.conf`:

```nginx
server {
    listen       80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
```

Por lo tanto, podemos concluir que colocando un fichero índice en la ruta raíz (de hecho siempre existe uno por defecto), deberíamos poder acceder a nuestro servidor web en el puerto 80 de la máquina.

Veamos el contenido del fichero de índice que está creado por defecto:

→ `/usr/share/nginx/html/index.html`

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Welcome to nginx!</title>
    <style>
      html {
        color-scheme: light dark;
      }
      body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
      }
    </style>
  </head>
  <body>
    <h1>Welcome to nginx!</h1>
    <p>
      If you see this page, the nginx web server is successfully installed and
      working. Further configuration is required.
    </p>

    <p>
      For online documentation and support please refer to
      <a href="http://nginx.org/">nginx.org</a>.<br />
      Commercial support is available at
      <a href="http://nginx.com/">nginx.com</a>.
    </p>

    <p><em>Thank you for using nginx.</em></p>
  </body>
</html>
```

Es por esto que cuando accedemos a http://localhost obtenemos esta página:

![Nginx Inicio](./images/nginx-boot.png)

> 💡 &nbsp;Tras una modificación de Nginx debemos recargar el servicio para que los cambios tengan efecto.

### Creación de un host virtual

Para crear un _virtual host_ debemos preparar un fichero de configuración:

```console
sdelquin@lemon:~$ sudo vi /etc/nginx/conf.d/helloworld.conf
```

```nginx
server {
	server_name helloworld;
	root /home/sdelquin/www/helloworld;
}
```

Podemos comprobar que la sintaxis sea correcta:

```console
sdelquin@lemon:~$ sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

A continuación tenemos que crear un fichero de índice en la carpeta raíz:

```console
sdelquin@lemon:~$ mkdir -p ~/www/helloworld
sdelquin@lemon:~$ vi ~/www/helloworld/index.html
```

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>HTML 5 Boilerplate</title>
    <link rel="stylesheet" href="style.css" />
  </head>
  <body>
    <h1>Hello World!</h1>
    <script src="index.js"></script>
  </body>
</html>
```

Ahora recargamos la configuración en Nginx para que el nuevo _virtual host_ sea detectado:

```console
delquin@lemon:~$ sudo systemctl reload nginx
```

Lo único que faltaría es simular un nombre de dominio a través de la configuración local:

```console
sdelquin@lemon:~$ sudo vi /etc/hosts
```

Añadir la línea:

```
127.0.0.1	helloworld
```

Esto hará que las peticiones a `hellworld` sean resueltas a la ip local `127.0.0.1`. Dado que el _virtual host_ está configurado para atender peticiones en ese dominio, pues todo debería funcionar:

```console
sdelquin@lemon:~$ firefox helloworld
```

![Hello World](./images/hello-world.png)

## Directivas

Existen [multitud de directivas](https://nginx.org/en/docs/dirindex.html) para Nginx. En esta sección veremos las que se consideran más relevantes para la puesta en funcionamiento de un servicio web.

### Ubicaciones

Los _virtual hosts_ permiten definir ubicaciones (**locations**) en su interior que serán gestionadas de forma independiente en función de su configuración.

A su vez, cada _location_ puede incluir las directivas correspondientes.

Supongamos que nuestro "Hello World" lo queremos montar sobre http://universe/helloworld. Procedemos de la siguiente manera:

```console
sdelquin@lemon:~$ sudo vi /etc/nginx/conf.d/universe.conf
```

> 💡 &nbsp;Es recomendable crear un fichero `*.conf` por cada nombre de dominio que vamos a utilizar.

```nginx
server {
	server_name universe;

    location /helloworld {
        root /home/sdelquin/www;  # /home/sdelquin/www/helloworld
    }
}
```

> 💡 &nbsp;Tener en cuenta que lo que pongamos en `location` se añade a `root` para determinar la ruta raíz del servicio.

Recordar siempre recargar el servicio Nginx cuando hagamos cambios en la configuración:

```console
sdelquin@lemon:~$ sudo systemctl reload nginx
```

Ahora si accedemos a http://localhost/helloworld podremos visualizar la página correctamente:

```console
sdelquin@lemon:~$ firefox universe/helloworld
```

![Nginx Location](./images/nginx-location.png)

> 💡 &nbsp;Recordar que hay que incluir la entrada correspondiente en `/etc/hosts` para que el nombre de dominio se resuelva localmente.

### Alias

Los "alias" son directivas que funcionan junto a los _locations_ y permiten evitar que se añada la ruta de la url al _root_.

Siguiendo con nuestro "Hello World" vamos a configurar un _location_ (mediante alias) para acceder al recurso en la url http://universe/hello:

```console
sdelquin@lemon:~$ sudo vi /etc/nginx/conf.d/universe.conf
```

```nginx
server {
    server_name universe;

    # ...

    location /hello {
        alias /home/sdelquin/www/helloworld;
    }
}
```

Recargamos la configuración y accedemos en el navegador:

![Nginx Alias](./images/nginx-alias.png)

> 💡 &nbsp;Un alias también se puede hacer "apuntar" a un fichero, no únicamente a un directorio/carpeta.

### Listado de directorios

La directiva `autoindex` nos permite listar el contenido del directorio indicado, pudiendo implementar una especie de FTP (lectura) a través del navegador.

Vamos a ejemplificar este escenario listando el contenido de la carpeta `/etc/nginx` cuando accedamos a http://universe/files.

Editamos el _virtual host_ con el que venimos trabajando:

```console
sdelquin@lemon:~$ sudo vi /etc/nginx/conf.d/universe.conf
```

```nginx
server {
    server_name universe;

    # ...

    location /files {
        alias /etc/nginx;
        autoindex on;
    }
}
```

Después de recargar, podemos acceder a la URL y ver que se muestra el listado de ficheros que hay en la ruta especificada:

```console
sdelquin@lemon:~$ firefox universe/files
```

![Nginx Autoindex](./images/nginx-autoindex.png)

### Acceso protegido

En ciertos escenarios es posible que queramos añadir una validación de credenciales para acceder a un recurso web. En este caso podemos hacer uso de las **directivas de autenticación**.

Lo primero es crear un fichero de credenciales `.htpasswd` con formato `<usuario>:<contraseña>`. En este caso vamos a usar:

- Usuario: `sdelquin`
- Contraseña: `systemd`

```console
sdelquin@lemon:~$ sudo sh -c "echo -n 'sdelquin:' >> /etc/nginx/.htpasswd"
sdelquin@lemon:~$ sudo sh -c "openssl passwd -apr1 systemd >> /etc/nginx/.htpasswd"
```

> 💡 &nbsp;Estamos usando la herramienta de openssl para [computar hashes](https://www.openssl.org/docs/man1.1.1/man1/openssl-passwd.html).

Vamos a comprobar que el fichero se ha creado correctamente y que la contraseña no está en claro 😅:

```console
sdelquin@lemon:~$ sudo cat /etc/nginx/.htpasswd
sdelquin:$apr1$A.UE2T7J$qgt0pRnZ99ePuDukgi/oh/
```

Ahora debemos hacer una pequeña modificación a nuestro _virtual host_ para añadir la autenticación:

```console
sdelquin@lemon:~$ sudo vi /etc/nginx/conf.d/universe.conf
```

```nginx
server {
    server_name universe;

    # ...

    location /files {
        alias /etc/nginx;
        autoindex on;
        auth_basic "Restricted area";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
}
```

Hemos añadido las directivas `auth_basic` y `auth_basic_user_file`.

Tras recargar la configuración y acceder a http://localhost/files vemos que nos aparece el diálogo para autenticarnos:

![Nginx Auth](./images/nginx-auth.png)

Tras introducir nuestras credenciales ya podemos ver el listado de ficheros:

![Nginx Autoindex](./images/nginx-autoindex.png)

## Módulos

Cuando Nginx se compila se hace incluyendo una serie de **módulos estáticos** que le otorgan ciertas funcionalidades extra:

```console
sdelquin@lemon:~$ sudo nginx -V 2>&1 | tr ' ' '\n' | grep module
--modules-path=/usr/lib/nginx/modules
--with-http_addition_module
--with-http_auth_request_module
--with-http_dav_module
--with-http_flv_module
--with-http_gunzip_module
--with-http_gzip_static_module
--with-http_mp4_module
--with-http_random_index_module
--with-http_realip_module
--with-http_secure_link_module
--with-http_slice_module
--with-http_ssl_module
--with-http_stub_status_module
--with-http_sub_module
--with-http_v2_module
--with-mail_ssl_module
--with-stream_realip_module
--with-stream_ssl_module
--with-stream_ssl_preread_module
```

Podemos inferir de la salida del comando anterior cuáles son los módulos incluidos en el proceso de compilación. La documentación de cada uno de ellos se puede consultar en https://nginx.org/en/docs/

Desde la versión 1.11.5 de Nginx se pueden incorporar **módulos dinámicos**. Estos módulos permiten la carga "a posteriori" de la compilación inicial y se cargan desde la carpeta `/etc/nginx/modules`.

> [Librerías estáticas (`*.a`) vs Librerías dinámicas (`*.so`)](https://medium.com/swlh/linux-basics-static-libraries-vs-dynamic-libraries-a7bcf8157779)

Nginx se puede extender haciendo uso de módulos propios o módulos de la comunidad:

| Módulos CORE               | Módulos de terceros                           |
| -------------------------- | --------------------------------------------- |
| https://nginx.org/en/docs/ | https://www.nginx.com/resources/wiki/modules/ |

### Instalación de un módulo

Vamos a instalar un módulo de terceros para Nginx y cargarlo dinámicamente. En este caso hemos escogido [Fancy Index](https://www.nginx.com/resources/wiki/modules/fancy_index/) que permite visualizar de manera más "bonita" un listado de ficheros.

Dado que vamos a realizar un proceso de compilación, primero necesitamos tener instaladas ciertas dependencias:

```console
sdelquin@lemon:~$  sudo apt install libpcre3-dev
```

Posteriormente tenemos que **descargar el código fuente de Nginx** con la misma versión que tenemos instalada en el sistema. Para ello:

```console
sdelquin@lemon:~$ curl -sL https://nginx.org/download/nginx-$(/sbin/nginx -v |& cut -d '/' -f2).tar.gz | tar xvz -C /tmp
```

Ahora pasamos a **descargar el código fuente del módulo** en cuestión. En este caso el de Fancy Index:

```console
sdelquin@lemon:~$ git clone https://github.com/aperezdc/ngx-fancyindex.git /tmp/ngx-fancyindex
Clonando en '/tmp/ngx-fancyindex'...
remote: Enumerating objects: 944, done.
remote: Counting objects: 100% (156/156), done.
remote: Compressing objects: 100% (77/77), done.
remote: Total 944 (delta 81), reused 128 (delta 73), pack-reused 788
Recibiendo objetos: 100% (944/944), 274.95 KiB | 1.52 MiB/s, listo.
Resolviendo deltas: 100% (534/534), listo.
```

Nos movemos a la carpeta donde hemos descargado el código fuente de Nginx y realizamos la **configuración de la compilación**:

```console
sdelquin@lemon:~$ cd /tmp/nginx-$(/sbin/nginx -v |& cut -d '/' -f2)
sdelquin@lemon:/tmp/nginx-1.22.0$ ./configure --add-dynamic-module=../ngx-fancyindex --with-compat
...
```

A continuación generamos la librería dinámica:

```console
sdelquin@lemon:/tmp/nginx-1.22.0$ make modules
...
```

Este proceso habrá creado un fichero `.so` dentro de la carpeta `objs`. Lo copiaremos a la carpeta desde la que se cargan los módulos dinámicos de Nginx:

```console
sdelquin@lemon:/tmp/nginx-1.22.0$ sudo cp objs/ngx_http_fancyindex_module.so /etc/nginx/modules
sdelquin@lemon:~$ cd
```

Para que este módulo se cargue correctamente, hay que especificarlo en el fichero de configuración de Nginx:

```console
sdelquin@lemon:~$ sudo vi /etc/nginx/nginx.conf
```

```nginx
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;

# Añadir aquí ↓
load_module /etc/nginx/modules/ngx_http_fancyindex_module.so;
# Añadir aquí ↑

events {
    worker_connections  1024;
}

# ...
```

Ahora ya podemos añadir las directivas del módulo a la configuración del _virtual host_. Modificamos el archivo `/etc/nginx/conf.d/universe.conf` de la siguiente manera:

```nginx
server {
	server_name universe;
    # ...

    location /files {
        alias /etc/nginx;
        fancyindex on;              # Enable fancy indexes.
        fancyindex_exact_size off;  # Output human-readable file sizes.
    }
}
```

Por supuesto hemos de recargar la configuración de Nginx para que estos cambios surtan efecto:

```console
sdelquin@lemon:~$ sudo systemctl reload nginx
```

Ahora, si accedemos a http://universe/files veremos algo similar a lo siguiente:

![Fancy index](./images/fancy-index.png)
