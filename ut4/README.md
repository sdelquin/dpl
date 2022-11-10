# UT4: Administración de servidores de aplicaciones

En esta unidad vamos a abordar el despliegue de aplicaciones escritas en distintos lenguajes de programación y sobre los frameworks web más utilizados en el momento.

Vamos a desarrollar una aplicación web muy sencilla denominada **TravelRoad** que se encargará de mostrar por pantalla aquellos destinos que ya hemos visitado y aquellos que aún nos quedan por visitar.

[PostgreSQL](#postgresql)  
[Laravel](#laravel)  
[Express](#express)  
[Flask](#flask)  
[Ruby on Rails](#ruby-on-rails)  
[Spring](#spring)

## PostgreSQL

![PostgreSQL Logo](./images/postgresql-logo.jpg)

### Instalación

Para la **capa de datos** de la aplicación que vamos a desplegar, necesitamos un sistema gestor de bases de datos. Trabajaremos sobre [PostgreSQL](<[https://](https://www.postgresql.org/)>): _"The World's Most Advanced Open Source Relational Database"_.

Lo primero será **actualizar los repositorios**:

```console
sdelquin@lemon:~$ sudo apt update
Des:1 http://security.debian.org/debian-security bullseye-security InRelease [48,4 kB]
Obj:2 http://deb.debian.org/debian bullseye InRelease
Des:3 http://deb.debian.org/debian bullseye-updates InRelease [44,1 kB]
Des:4 https://download.docker.com/linux/debian bullseye InRelease [43,3 kB]
Des:5 http://security.debian.org/debian-security bullseye-security/main Sources [167 kB]
Des:6 http://deb.debian.org/debian bullseye-updates/main Sources.diff/Index [15,1 kB]
Des:7 https://download.docker.com/linux/debian bullseye/stable arm64 Packages [13,7 kB]
Des:8 http://security.debian.org/debian-security bullseye-security/main arm64 Packages [191 kB]
Des:9 http://deb.debian.org/debian bullseye-updates/main arm64 Packages.diff/Index [15,1 kB]
Des:10 http://security.debian.org/debian-security bullseye-security/main Translation-en [122 kB]
Des:11 http://deb.debian.org/debian bullseye-updates/main Sources T-2022-10-31-2015.41-F-2022-10-31-2015.41.pdiff [391 B]
Des:11 http://deb.debian.org/debian bullseye-updates/main Sources T-2022-10-31-2015.41-F-2022-10-31-2015.41.pdiff [391 B]
Des:12 http://deb.debian.org/debian bullseye-updates/main arm64 Packages T-2022-10-31-2015.41-F-2022-10-31-2015.41.pdiff [286 B]
Des:12 http://deb.debian.org/debian bullseye-updates/main arm64 Packages T-2022-10-31-2015.41-F-2022-10-31-2015.41.pdiff [286 B]
Des:13 http://nginx.org/packages/debian bullseye InRelease [2.866 B]
Des:14 http://nginx.org/packages/debian bullseye/nginx arm64 Packages [13,2 kB]
Des:15 https://packages.sury.org/php bullseye InRelease [6.841 B]
Des:16 https://packages.sury.org/php bullseye/main arm64 Packages [336 kB]
Des:17 http://packages.microsoft.com/repos/code stable InRelease [10,4 kB]
Des:18 http://packages.microsoft.com/repos/code stable/main arm64 Packages [118 kB]
Des:19 http://packages.microsoft.com/repos/code stable/main amd64 Packages [116 kB]
Des:20 http://packages.microsoft.com/repos/code stable/main armhf Packages [118 kB]
Descargados 1.383 kB en 6s (243 kB/s)
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Se pueden actualizar 78 paquetes. Ejecute «apt list --upgradable» para verlos.
```

A continuación instalaremos **algunos paquetes de soporte**:

```console
sdelquin@lemon:~$ sudo apt install -y apt-transport-https
[sudo] password for sdelquin:
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
apt-transport-https ya está en su versión más reciente (2.2.4).
0 actualizados, 0 nuevos se instalarán, 0 para eliminar y 78 no actualizados.
```

A continuación descargamos la **clave de firma** para el repositorio oficial de PostgreSQL:

```console
sdelquin@lemon:~$ curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc \
| sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
```

**Añadimos el repositorio oficial de PostgreSQL** al sistema:

```console
sdelquin@lemon:~$ echo 'deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main' \
| sudo tee /etc/apt/sources.list.d/postgresql.list > /dev/null
```

Ahora volvemos a **actualizar la paquetería**:

```console
sdelquin@lemon:~$ sudo apt update
Obj:1 http://security.debian.org/debian-security bullseye-security InRelease
Obj:2 http://deb.debian.org/debian bullseye InRelease
Obj:3 http://deb.debian.org/debian bullseye-updates InRelease
Obj:4 https://download.docker.com/linux/debian bullseye InRelease
Obj:5 http://packages.microsoft.com/repos/code stable InRelease
Obj:6 http://nginx.org/packages/debian bullseye InRelease
Des:7 http://apt.postgresql.org/pub/repos/apt bullseye-pgdg InRelease [91,7 kB]
Obj:8 https://packages.sury.org/php bullseye InRelease
Des:9 http://apt.postgresql.org/pub/repos/apt bullseye-pgdg/main arm64 Packages [254 kB]
Descargados 346 kB en 1s (273 kB/s)
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Se pueden actualizar 78 paquetes. Ejecute «apt list --upgradable» para verlos.
```

Lo más probable es que dispongamos de **distintas versiones de PostgreSQL**. Con el siguiente comando podemos comprobarlo:

```console
sdelquin@lemon:~$ apt-cache search --names-only 'postgresql-[0-9]+$' | sort
postgresql-10 - The World's Most Advanced Open Source Relational Database
postgresql-11 - The World's Most Advanced Open Source Relational Database
postgresql-12 - The World's Most Advanced Open Source Relational Database
postgresql-13 - The World's Most Advanced Open Source Relational Database
postgresql-14 - The World's Most Advanced Open Source Relational Database
postgresql-15 - The World's Most Advanced Open Source Relational Database
```

Por tanto **instalamos la última versión**:

```console
sdelquin@lemon:~$ sudo apt install -y postgresql-15
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Se instalarán los siguientes paquetes adicionales:
  libcommon-sense-perl libjson-perl libjson-xs-perl libpq5 libtypes-serialiser-perl pgdg-keyring
  postgresql-client-15 postgresql-client-common postgresql-common sysstat
Paquetes sugeridos:
  postgresql-doc-15 isag
Se instalarán los siguientes paquetes NUEVOS:
  libcommon-sense-perl libjson-perl libjson-xs-perl libpq5 libtypes-serialiser-perl pgdg-keyring
  postgresql-15 postgresql-client-15 postgresql-client-common postgresql-common sysstat
0 actualizados, 11 nuevos se instalarán, 0 para eliminar y 78 no actualizados.
Se necesita descargar 18,6 MB de archivos.
Se utilizarán 63,3 MB de espacio de disco adicional después de esta operación.
Des:1 http://deb.debian.org/debian bullseye/main arm64 libjson-perl all 4.03000-1 [88,6 kB]
Des:2 http://deb.debian.org/debian bullseye/main arm64 libcommon-sense-perl arm64 3.75-1+b4 [24,6 kB]
Des:3 http://deb.debian.org/debian bullseye/main arm64 libtypes-serialiser-perl all 1.01-1 [12,2 kB]
Des:4 http://deb.debian.org/debian bullseye/main arm64 libjson-xs-perl arm64 4.030-1+b1 [93,7 kB]
Des:5 http://deb.debian.org/debian bullseye/main arm64 sysstat arm64 12.5.2-2 [581 kB]
Des:6 http://apt.postgresql.org/pub/repos/apt bullseye-pgdg/main arm64 pgdg-keyring all 2018.2 [10,7 kB]
Des:7 http://apt.postgresql.org/pub/repos/apt bullseye-pgdg/main arm64 postgresql-client-common all 244.pgdg110+1 [92,0 kB]
Des:8 http://apt.postgresql.org/pub/repos/apt bullseye-pgdg/main arm64 postgresql-common all 244.pgdg110+1 [232 kB]
Des:9 http://apt.postgresql.org/pub/repos/apt bullseye-pgdg/main arm64 libpq5 arm64 15.0-1.pgdg110+1 [171 kB]
Des:10 http://apt.postgresql.org/pub/repos/apt bullseye-pgdg/main arm64 postgresql-client-15 arm64 15.0-1.pgdg110+1 [1.609 kB]
Des:11 http://apt.postgresql.org/pub/repos/apt bullseye-pgdg/main arm64 postgresql-15 arm64 15.0-1.pgdg110+1 [15,7 MB]
Descargados 18,6 MB en 3s (6.469 kB/s)
Preconfigurando paquetes ...
Seleccionando el paquete libjson-perl previamente no seleccionado.
(Leyendo la base de datos ... 227992 ficheros o directorios instalados actualmente.)
Preparando para desempaquetar .../00-libjson-perl_4.03000-1_all.deb ...
Desempaquetando libjson-perl (4.03000-1) ...
Seleccionando el paquete pgdg-keyring previamente no seleccionado.
Preparando para desempaquetar .../01-pgdg-keyring_2018.2_all.deb ...
Desempaquetando pgdg-keyring (2018.2) ...
Seleccionando el paquete postgresql-client-common previamente no seleccionado.
Preparando para desempaquetar .../02-postgresql-client-common_244.pgdg110+1_all.deb ...
Desempaquetando postgresql-client-common (244.pgdg110+1) ...
Seleccionando el paquete postgresql-common previamente no seleccionado.
Preparando para desempaquetar .../03-postgresql-common_244.pgdg110+1_all.deb ...
Añadiendo `desviación de /usr/bin/pg_config a /usr/bin/pg_config.libpq-dev por postgresql-common'
Desempaquetando postgresql-common (244.pgdg110+1) ...
Seleccionando el paquete libcommon-sense-perl previamente no seleccionado.
Preparando para desempaquetar .../04-libcommon-sense-perl_3.75-1+b4_arm64.deb ...
Desempaquetando libcommon-sense-perl (3.75-1+b4) ...
Seleccionando el paquete libtypes-serialiser-perl previamente no seleccionado.
Preparando para desempaquetar .../05-libtypes-serialiser-perl_1.01-1_all.deb ...
Desempaquetando libtypes-serialiser-perl (1.01-1) ...
Seleccionando el paquete libjson-xs-perl previamente no seleccionado.
Preparando para desempaquetar .../06-libjson-xs-perl_4.030-1+b1_arm64.deb ...
Desempaquetando libjson-xs-perl (4.030-1+b1) ...
Seleccionando el paquete libpq5:arm64 previamente no seleccionado.
Preparando para desempaquetar .../07-libpq5_15.0-1.pgdg110+1_arm64.deb ...
Desempaquetando libpq5:arm64 (15.0-1.pgdg110+1) ...
Seleccionando el paquete postgresql-client-15 previamente no seleccionado.
Preparando para desempaquetar .../08-postgresql-client-15_15.0-1.pgdg110+1_arm64.deb ...
Desempaquetando postgresql-client-15 (15.0-1.pgdg110+1) ...
Seleccionando el paquete postgresql-15 previamente no seleccionado.
Preparando para desempaquetar .../09-postgresql-15_15.0-1.pgdg110+1_arm64.deb ...
Desempaquetando postgresql-15 (15.0-1.pgdg110+1) ...
Seleccionando el paquete sysstat previamente no seleccionado.
Preparando para desempaquetar .../10-sysstat_12.5.2-2_arm64.deb ...
Desempaquetando sysstat (12.5.2-2) ...
Configurando pgdg-keyring (2018.2) ...
Configurando libpq5:arm64 (15.0-1.pgdg110+1) ...
Configurando libcommon-sense-perl (3.75-1+b4) ...
Configurando libtypes-serialiser-perl (1.01-1) ...
Configurando libjson-perl (4.03000-1) ...
Configurando sysstat (12.5.2-2) ...

Creating config file /etc/default/sysstat with new version
update-alternatives: utilizando /usr/bin/sar.sysstat para proveer /usr/bin/sar (sar) en modo automát
ico
Created symlink /etc/systemd/system/sysstat.service.wants/sysstat-collect.timer → /lib/systemd/syste
m/sysstat-collect.timer.
Created symlink /etc/systemd/system/sysstat.service.wants/sysstat-summary.timer → /lib/systemd/syste
m/sysstat-summary.timer.
Created symlink /etc/systemd/system/multi-user.target.wants/sysstat.service → /lib/systemd/system/sy
sstat.service.
Configurando postgresql-client-common (244.pgdg110+1) ...
Configurando libjson-xs-perl (4.030-1+b1) ...
Configurando postgresql-client-15 (15.0-1.pgdg110+1) ...
update-alternatives: utilizando /usr/share/postgresql/15/man/man1/psql.1.gz para proveer /usr/share/
man/man1/psql.1.gz (psql.1.gz) en modo automático
Configurando postgresql-common (244.pgdg110+1) ...
Añadiendo al usuario postgres al grupo ssl-cert

Creating config file /etc/postgresql-common/createcluster.conf with new version
Building PostgreSQL dictionaries from installed myspell/hunspell packages...
  en_us
Removing obsolete dictionary files:
Created symlink /etc/systemd/system/multi-user.target.wants/postgresql.service → /lib/systemd/system
/postgresql.service.
Configurando postgresql-15 (15.0-1.pgdg110+1) ...
Creating new PostgreSQL cluster 15/main ...
/usr/lib/postgresql/15/bin/initdb -D /var/lib/postgresql/15/main --auth-local peer --auth-host scram
-sha-256 --no-instructions
Los archivos de este cluster serán de propiedad del usuario «postgres».
Este usuario también debe ser quien ejecute el proceso servidor.

El cluster será inicializado con configuración regional «es_ES.UTF-8».
La codificación por omisión ha sido por lo tanto definida a «UTF8».
La configuración de búsqueda en texto ha sido definida a «spanish».

Las sumas de verificación en páginas de datos han sido desactivadas.

corrigiendo permisos en el directorio existente /var/lib/postgresql/15/main ... hecho
creando subdirectorios ... hecho
seleccionando implementación de memoria compartida dinámica ... posix
seleccionando el valor para max_connections ... 100
seleccionando el valor para shared_buffers ... 128MB
seleccionando el huso horario por omisión ... Atlantic/Canary
creando archivos de configuración ... hecho
ejecutando script de inicio (bootstrap) ... hecho
realizando inicialización post-bootstrap ... hecho
sincronizando los datos a disco ... hecho
update-alternatives: utilizando /usr/share/postgresql/15/man/man1/postmaster.1.gz para proveer /usr/
share/man/man1/postmaster.1.gz (postmaster.1.gz) en modo automático
Procesando disparadores para man-db (2.9.4-2) ...
Procesando disparadores para libc-bin (2.31-13+deb11u4) ...
```

Revisamos que la **versión instalada** sea la correcta:

```console
sdelquin@lemon:~$ psql --version
psql (PostgreSQL) 15.0 (Debian 15.0-1.pgdg110+1)
```

Tras la instalación, el **servicio PostgreSQL se arrancará automáticamente**. Podemos comprobarlo de la siguiente manera:

```console
sdelquin@lemon:~$ sudo systemctl status postgresql
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor preset: enabled)
     Active: active (exited) since Tue 2022-11-01 11:03:54 WET; 2min 2s ago
   Main PID: 751384 (code=exited, status=0/SUCCESS)
      Tasks: 0 (limit: 2251)
     Memory: 0B
        CPU: 0
     CGroup: /system.slice/postgresql.service

nov 01 11:03:54 lemon systemd[1]: Starting PostgreSQL RDBMS...
nov 01 11:03:54 lemon systemd[1]: Finished PostgreSQL RDBMS.
```

Ahora vamos a iniciar sesión en el sistema gestor de bases de datos:

```console
sdelquin@lemon:~$ sudo -u postgres psql
psql (15.0 (Debian 15.0-1.pgdg110+1))
Digite «help» para obtener ayuda.

postgres=#
```

### Base de datos

Vamos a crear una **base de datos** y un **rol de acceso** a la misma:

```console
sdelquin@lemon:~$ sudo -u postgres psql
psql (15.0 (Debian 15.0-1.pgdg110+1))
Digite «help» para obtener ayuda.

postgres=# CREATE USER travelroad_user WITH ENCRYPTED PASSWORD 'dpl0000';
CREATE ROLE
postgres=# CREATE DATABASE travelroad WITH OWNER travelroad_user;
CREATE DATABASE
postgres=# \q
```

A continuación accedemos al intérprete PostgreSQL **con el nuevo usuario**:

```console
sdelquin@lemon:~$ psql -h localhost -U travelroad_user travelroad
Contraseña para usuario travelroad_user:
psql (15.0 (Debian 15.0-1.pgdg110+1))
Conexión SSL (protocolo: TLSv1.3, cifrado: TLS_AES_256_GCM_SHA384, compresión: desactivado)
Digite «help» para obtener ayuda.

travelroad=>
```

Ahora ya podemos **crear la tabla de lugares**:

```sql
travelroad=> CREATE TABLE places(
id SERIAL PRIMARY KEY,
name VARCHAR(255),
visited BOOLEAN);
CREATE TABLE
```

Obviamente empezamos con la tabla vacía:

```sql
travelroad=> SELECT * FROM places;
 id | name | visited
----+------+---------
(0 filas)
```

### Carga de datos

Vamos a cargar los datos desde este fichero [places.csv](./files/places.csv) a la tabla `places`.

Lo primero será **descargar el fichero CSV**:

```console
sdelquin@lemon:~$ curl -o /tmp/places.csv https://raw.githubusercontent.com/sdelquin/dpl/main/ut4/files/places.csv
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   142  100   142    0     0    402      0 --:--:-- --:--:-- --:--:--   402
```

A continuación usaremos la función `copy` de PostgreSQL para **insertar los datos en la tabla**:

```console
sdelquin@lemon:~$ psql -h localhost -U travelroad_user -d travelroad \
-c "\copy places(name, visited) FROM '/tmp/places.csv' DELIMITER ','"

Contraseña para usuario travelroad_user:
COPY 11
```

**Comprobamos** que los datos se han insertado de manera adecuada:

```console
sdelquin@lemon:~$ psql -h localhost -U travelroad_user travelroad
Contraseña para usuario travelroad_user:
psql (15.0 (Debian 15.0-1.pgdg110+1))
Conexión SSL (protocolo: TLSv1.3, cifrado: TLS_AES_256_GCM_SHA384, compresión: desactivado)
Digite «help» para obtener ayuda.
```

```sql
travelroad=> SELECT * FROM places;
 id |    name    | visited
----+------------+---------
  1 | Tokio      | f
  2 | Budapest   | t
  3 | Nairobi    | f
  4 | Berlín     | t
  5 | Lisboa     | t
  6 | Denver     | f
  7 | Moscú      | f
  8 | Oslo       | f
  9 | Río        | t
 10 | Cincinnati | f
 11 | Helsinki   | f
(11 filas)
```

## Laravel

![Laravel Logo](./images/laravel-logo.jpg)

[Laravel](https://laravel.com/) es un framework de código abierto para desarrollar aplicaciones y servicios web con **PHP**.

### Instalación

#### Composer

Lo primero que necesitamos es un gestor de dependencias para PHP. Vamos a instalar [Composer](<[https://](https://getcomposer.org/)>):

```console
sdelquin@lemon:~$ curl -fsSL https://raw.githubusercontent.com/composer/getcomposer.org/main/web/installer \
| php -- --quiet | sudo mv composer.phar /usr/local/bin/composer
```

Comprobamos la versión instalada:

```console
sdelquin@lemon:~$ composer --version
Composer version 2.4.4 2022-10-27 14:39:29
```

#### Paquetes de soporte

Necesitamos **ciertos módulos PHP** habilitados en el sistema. Para ello instalamos los siguientes paquetes soporte:

```console
sdelquin@lemon:~$ sudo apt install -y php8.2-mbstring php8.2-xml php8.2-bcmath php8.2-curl php8.2-pgsql
```

#### Aplicación

Ahora ya podemos crear la estructura de nuestra aplicación Laravel. Para ello utilizamos `composer`:

```console
sdelquin@lemon:~$ composer create-project --prefer-dist laravel/laravel travelroad
```

> 💡 El comando anterior creará una carpeta `travelround` con todas las dependencias que necesitamos.

Entramos en la carpeta de trabajo y probamos [artisan](https://laravel.com/docs/9.x/artisan), la interfaz en línea de comandos para Laravel:

```console
sdelquin@lemon:~$ cd travelroad/

sdelquin@lemon:~/travelroad$ php artisan --version
Laravel Framework 9.38.0
```

Ahora tenemos que **configurar ciertas variables** en el fichero `.env`:

```console
sdelquin@lemon:~/travelroad$ vi .env
```

```ini
...
APP_NAME=TravelRoad
APP_ENV=development
...
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=travelroad
DB_USERNAME=travelroad_user
DB_PASSWORD=dpl0000
...
```

### Configuración Nginx

Lo primero será fijar los **permisos adecuados a los ficheros del proyecto** para que los servicios Nginx+PHP-FPM pueda trabajar sin errores de acceso:

```console
sdelquin@lemon:~$ cd ~/travelroad/

sdelquin@lemon:~/travelroad$ sudo chown -R $USER:nginx .

sdelquin@lemon:~/travelroad$ sudo chgrp -R nginx storage bootstrap/cache
sdelquin@lemon:~/travelroad$ sudo chmod -R ug+rwx storage bootstrap/cache
```

La **configuración del _virtual host_ Nginx** para nuestra aplicación Laravel la vamos a hacer en un fichero específico:

```console
sdelquin@lemon:~$ sudo vi /etc/nginx/conf.d/travelroad.conf
```

> Contenido:

```nginx
server {
    listen 80;
    server_name travelroad;
    root /home/sdelquin/travelroad/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```

> 💡 Recordar añadir `travelroad` al fichero `/etc/hosts` en caso de estar trabajando en local.

**Comprobamos la sintaxis** del fichero y, si todo ha ido bien, **recargamos la configuración** Nginx:

```console
sdelquin@lemon:~$ sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

sdelquin@lemon:~$ sudo systemctl reload nginx
```

Ya podemos abrir el navegador en http://travelroad para ver que todo está funcionando correctamente:

```console
sdelquin@lemon:~$ firefox http://travelroad
```

![Laravel Init](./images/laravel-init.png)

### Lógica de negocio

Nos queda modificar el comportamiento de la aplicación para cargar los datos y mostrarlos en una plantilla.

Lo primero es **cambiar el código de la ruta**:

```console
sdelquin@lemon:~$ cd travelroad/
sdelquin@lemon:~/travelroad$ vi routes/web.php
```

> Contenido:

```php
<?php

use Illuminate\Support\Facades\DB;

Route::get('/', function () {
  $visited = DB::select('select * from places where visited = ?', [1]);
  $togo = DB::select('select * from places where visited = ?', [0]);

  return view('travelroad', ['visited' => $visited, 'togo' => $togo ] );
});
```

Lo segundo es **escribir la plantilla** que renderiza los datos:

```console
sdelquin@lemon:~/travelroad$ vi resources/views/travelroad.blade.php
```

> Contenido:

```html
<html>
  <head>
    <title>Travel List</title>
  </head>

  <body>
    <h1>My Travel Bucket List</h1>
    <h2>Places I'd Like to Visit</h2>
    <ul>
      @foreach ($togo as $newplace)
      <li>{{ $newplace->name }}</li>
      @endforeach
    </ul>

    <h2>Places I've Already Been To</h2>
    <ul>
      @foreach ($visited as $place)
      <li>{{ $place->name }}</li>
      @endforeach
    </ul>
  </body>
</html>
```

Ya podemos abrir el navegador en http://travelroad para ver que todo está funcionando correctamente:

```console
sdelquin@lemon:~$ firefox http://travelroad
```

![Laravel Works](./images/laravel-works.png)

## Express

![Express Logo](./images/express-logo.png)

[Express](https://expressjs.com/) es un framework web mínimo y flexible para Node.js.

### Instalación

#### Node.js

Lo primero que debemos instalar es [Node.js](<[https://](https://nodejs.org/es/)>): un entorno de ejecución para JavaScript construido con [V8, motor de JavaScript de Chrome](https://v8.dev/).

Existe un instalador que nos facilita **añadir los repositorios oficiales de Node.js**. El comando a ejecutar es el siguiente:

```console
sdelquin@lemon:~$ curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash
[sudo] password for sdelquin:

## Installing the NodeSource Node.js 19.x repo...


## Populating apt-get cache...

+ apt-get update
Obj:1 http://deb.debian.org/debian bullseye InRelease
Des:2 https://download.docker.com/linux/debian bullseye InRelease [43,3 kB]
Des:3 http://security.debian.org/debian-security bullseye-security InRelease [48,4 kB]
Obj:4 https://packages.sury.org/php bullseye InRelease
Des:5 http://deb.debian.org/debian bullseye-updates InRelease [44,1 kB]
Des:6 http://nginx.org/packages/debian bullseye InRelease [2.866 B]
Des:7 http://security.debian.org/debian-security bullseye-security/main Sources [167 kB]
Des:8 http://packages.microsoft.com/repos/code stable InRelease [10,4 kB]
Des:9 http://apt.postgresql.org/pub/repos/apt bullseye-pgdg InRelease [91,7 kB]
Des:10 http://security.debian.org/debian-security bullseye-security/main arm64 Packages [192 kB]
Des:11 http://packages.microsoft.com/repos/code stable/main arm64 Packages [119 kB]
Des:12 http://security.debian.org/debian-security bullseye-security/main Translation-en [123 kB]
Des:13 http://packages.microsoft.com/repos/code stable/main armhf Packages [119 kB]
Des:14 http://packages.microsoft.com/repos/code stable/main amd64 Packages [117 kB]
Des:15 http://apt.postgresql.org/pub/repos/apt bullseye-pgdg/main arm64 Packages [256 kB]
Descargados 1.334 kB en 2s (597 kB/s)
Leyendo lista de paquetes... Hecho

## Confirming "bullseye" is supported...

+ curl -sLf -o /dev/null 'https://deb.nodesource.com/node_19.x/dists/bullseye/Release'

## Adding the NodeSource signing key to your keyring...

+ curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee /usr/share/keyrings/nodesource.gpg >/dev/null
gpg: AVISO: propiedad insegura del directorio personal '/home/sdelquin/.gnupg'

## Creating apt sources list file for the NodeSource Node.js 19.x repo...

+ echo 'deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_19.x bullseye main' > /etc/apt/sources.list.d/nodesource.list
+ echo 'deb-src [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_19.x bullseye main' >> /etc/apt/sources.list.d/nodesource.list

## Running `apt-get update` for you...

+ apt-get update
Obj:1 http://security.debian.org/debian-security bullseye-security InRelease
Obj:2 http://apt.postgresql.org/pub/repos/apt bullseye-pgdg InRelease
Obj:3 http://deb.debian.org/debian bullseye InRelease
Obj:4 http://deb.debian.org/debian bullseye-updates InRelease
Obj:5 http://packages.microsoft.com/repos/code stable InRelease
Obj:6 https://download.docker.com/linux/debian bullseye InRelease
Obj:7 http://nginx.org/packages/debian bullseye InRelease
Obj:8 https://packages.sury.org/php bullseye InRelease
Des:9 https://deb.nodesource.com/node_19.x bullseye InRelease [4.586 B]
Des:10 https://deb.nodesource.com/node_19.x bullseye/main arm64 Packages [772 B]
Descargados 5.358 B en 1s (4.180 B/s)
Leyendo lista de paquetes... Hecho

## Run `sudo apt-get install -y nodejs` to install Node.js 19.x and npm
## You may also need development tools to build native addons:
     sudo apt-get install gcc g++ make
## To install the Yarn package manager, run:
     curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
     echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
     sudo apt-get update && sudo apt-get install yarn
```

Ahora ya podemos **instalar Node.js de forma ordinaria**:

```console
sdelquin@lemon:~$ sudo apt install -y nodejs
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Se instalarán los siguientes paquetes NUEVOS:
  nodejs
0 actualizados, 1 nuevos se instalarán, 0 para eliminar y 78 no actualizados.
Se necesita descargar 28,3 MB de archivos.
Se utilizarán 183 MB de espacio de disco adicional después de esta operación.
Des:1 https://deb.nodesource.com/node_19.x bullseye/main arm64 nodejs arm64 19.0.1-deb-1nodesource1 [28,3 MB]
Descargados 28,3 MB en 4s (7.406 kB/s)
Seleccionando el paquete nodejs previamente no seleccionado.
(Leyendo la base de datos ... 230383 ficheros o directorios instalados actualmente.)
Preparando para desempaquetar .../nodejs_19.0.1-deb-1nodesource1_arm64.deb ...
Desempaquetando nodejs (19.0.1-deb-1nodesource1) ...
Configurando nodejs (19.0.1-deb-1nodesource1) ...
Procesando disparadores para man-db (2.9.4-2) ...
```

Comprobamos las versiones de Node.js y de [npm](<[https://](https://www.npmjs.com/)>) (sistema de gestión de paquetes para Node.js):

```console
sdelquin@lemon:~$ node --version
v19.0.1

sdelquin@lemon:~$ npm --version
8.19.2
```

#### Aplicación

Ahora ya podemos crear la estructura de nuestra aplicación Express. Para ello utilizamos `express-generator` una herramienta que debemos instalar de forma global en el sistema:

```console
sdelquin@lemon:~$ sudo npm install -g express-generator
[sudo] password for sdelquin:
npm WARN deprecated mkdirp@0.5.1: Legacy versions of mkdirp are no longer supported. Please update to mkdirp 1.x. (Note that the API surface has changed to use Promises in 1.x.)

added 10 packages, and audited 11 packages in 2s

4 vulnerabilities (1 moderate, 1 high, 2 critical)

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.
npm notice
npm notice New patch version of npm available! 8.19.2 -> 8.19.3
npm notice Changelog: https://github.com/npm/cli/releases/tag/v8.19.3
npm notice Run npm install -g npm@8.19.3 to update!
npm notice
```

Creamos la **estructura base de la aplicación**:

```console
sdelquin@lemon:~$ express --view=pug travelroad

   create : travelroad/
   create : travelroad/public/
   create : travelroad/public/javascripts/
   create : travelroad/public/images/
   create : travelroad/public/stylesheets/
   create : travelroad/public/stylesheets/style.css
   create : travelroad/routes/
   create : travelroad/routes/index.js
   create : travelroad/routes/users.js
   create : travelroad/views/
   create : travelroad/views/error.pug
   create : travelroad/views/index.pug
   create : travelroad/views/layout.pug
   create : travelroad/app.js
   create : travelroad/package.json
   create : travelroad/bin/
   create : travelroad/bin/www

   change directory:
     $ cd travelroad

   install dependencies:
     $ npm install

   run the app:
     $ DEBUG=travelroad:* npm start
```

> 💡 El comando anterior creará una carpeta `travelround` con la estructura base para poder desarrollar nuestra aplicación web.

Tal y como indica la salida del comando, ahora debemos **instalar las dependencias**:

```console
sdelquin@lemon:~$ cd travelroad

sdelquin@lemon:~/travelroad$ npm install
npm WARN deprecated core-js@2.6.12: core-js@<3.23.3 is no longer maintained and not recommended for usage due to the number of issues. Because of the V8 engine whims, feature detection in old core-js versions could cause a slowdown up to 100x even if nothing is polyfilled. Some versions have web compatibility issues. Please, upgrade your dependencies to the actual version of core-js.

added 124 packages, and audited 125 packages in 11s

8 packages are looking for funding
  run `npm fund` for details

4 vulnerabilities (2 low, 2 high)

To address issues that do not require attention, run:
  npm audit fix

To address all issues, run:
  npm audit fix --force

Run `npm audit` for details.
```

Ahora podemos **probar la aplicación** lanzando el servidor de desarrollo:

```console
sdelquin@lemon:~/travelroad$ DEBUG=travelroad:* npm start

> travelroad@0.0.0 start
> node ./bin/www

  travelroad:server Listening on port 3000 +0ms
```

En otra pestaña de terminal, abrimos con el navegador la dirección http://localhost:3000 obteniendo un resultado como éste:

![Express init](./images/express-init.png)

### Configuración de la base de datos

Para poder acceder a la base de datos PostgreSQL necesitamos una dependencia adicional [node-postgres](https://www.npmjs.com/package/pg). Realizamos la instalación:

```console
sdelquin@lemon:~/travelroad$ npm install pg

added 15 packages, and audited 140 packages in 6s

8 packages are looking for funding
  run `npm fund` for details

4 vulnerabilities (2 low, 2 high)

To address issues that do not require attention, run:
  npm audit fix

To address all issues, run:
  npm audit fix --force

Run `npm audit` for details.
```

Siempre es interesante guardar las credenciales en un fichero "externo". En este caso vamos a trabajar con un fichero `.env` con lo que necesitaremos el paquete [dotenv](<[https://](https://www.npmjs.com/package/dotenv)>). Lo instalamos:

```console
sdelquin@lemon:~/travelroad$ npm install dotenv

added 1 package, and audited 141 packages in 3s

8 packages are looking for funding
  run `npm fund` for details

4 vulnerabilities (2 low, 2 high)

To address issues that do not require attention, run:
  npm audit fix

To address all issues, run:
  npm audit fix --force

Run `npm audit` for details.
```

En este fichero hay que guardar la cadena de conexión a la base de datos PostgreSQL:

```console
sdelquin@lemon:~/travelroad$ echo 'PSQL_CONNECTION=postgresql://travelroad_user:dpl0000@localhost:5432/travelroad' > .env
```

### Lógica de negocio

Nos queda modificar el comportamiento de la aplicación para **cargar los datos** y **mostrarlos en una plantilla**.

#### Conexión a la base de datos

```console
sdelquin@lemon:~/travelroad$ mkdir config && vi config/database.js
```

> Contenido:

```js
const { Pool } = require("pg");
require("dotenv").config();
const connectionString = process.env.PSQL_CONNECTION;
const pool = new Pool({
  connectionString,
});

module.exports = {
  query: (text, params) => pool.query(text, params),
};
```

#### Gestión de las rutas

```console
sdelquin@lemon:~/travelroad$ vi routes/index.js
```

> Contenido:

```js
const db = require("../config/database");
var express = require("express");
var router = express.Router();

/* GET home page. */
router.get("/", async function (req, res, next) {
  const { rows: newplace } = await db.query(
    "SELECT * FROM places WHERE visited=$1",
    [0]
  );
  const { rows: visited } = await db.query(
    "SELECT * FROM places WHERE visited=$1",
    [1]
  );
  res.render("index", { newplace, visited });
});

module.exports = router;
```

#### Plantilla para la vista

```console
sdelquin@lemon:~/travelroad$ vi views/index.pug
```

> Contenido:

```pug
extends layout

block content
  h1= "My Travel Bucket List"
  h2= "Places I'd Like to Visit"
  ul
    each place in newplace
      li= place.name
  h2= "Places I've Already Been To"
  ul
    each place in visited
      li= place.name
```

Volvemos a **lanzar la aplicación**:

```console
sdelquin@lemon:~/travelroad$ DEBUG=travelroad:* npm start
```

Y comprobamos que la dirección http://localhost:3000 nos da el resultado que esperábamos:

![Express en desarrollo](./images/express-dev.png)

### Gestionando procesos

Vamos a hacer uso de [pm2](<[https://](https://www.npmjs.com/package/pm2)>) un **gestor de procesos** para aplicaciones Node.js en producción.

Lo primero es **instalar el paquete** de forma global en el sistema:

```console
sdelquin@lemon:~$ sudo npm install pm2 -g
[sudo] password for sdelquin:
npm WARN deprecated uuid@3.4.0: Please upgrade  to version 7 or higher.  Older versions may use Math.random() in certain circumstances, which is known to be problematic.  See https://v8.dev/blog/math-random for details.

added 184 packages, and audited 185 packages in 12s

12 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
```

Ahora ya podemos **lanzar un proceso en background** con nuestra aplicación. Estando en la carpeta de trabajo `~/travelroad` ejecutamos el siguiente comando:

```console
sdelquin@lemon:~/travelroad$ pm2 start ./bin/www --name travelroad
[PM2] Starting /home/sdelquin/travelroad/bin/www in fork_mode (1 instance)
[PM2] Done.
┌────┬────────────────────┬──────────┬──────┬───────────┬──────────┬──────────┐
│ id │ name               │ mode     │ ↺    │ status    │ cpu      │ memory   │
├────┼────────────────────┼──────────┼──────┼───────────┼──────────┼──────────┤
│ 0  │ travelroad         │ fork     │ 0    │ online    │ 0%       │ 22.6mb   │
└────┴────────────────────┴──────────┴──────┴───────────┴──────────┴──────────┘
```

### Configuración de Nginx

Lo único que nos queda es preparar el _virtual host_ en Nginx para comunicar con el proceso de Node.js:

```console
sdelquin@lemon:~$ sudo vi /etc/nginx/conf.d/travelroad.conf
```

> Contenido:

```nginx
server {
    listen 80;
    server_name travelroad;

    location / {
        proxy_pass http://localhost:3000;
    }
}
```

Recargamos la configuración de Nginx y accedemos a http://travelroad obteniendo el resultado esperado:

![ExpressJS funcionando](./images/express-works.png)
