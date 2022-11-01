# UT4: Administración de servidores de aplicaciones

En esta unidad vamos a abordar el despliegue de aplicaciones escritas en distintos lenguajes de programación y sobre los frameworks web más utilizados en el momento.

[Laravel](#laravel)  
[Flask](#flask)  
[Express](#express)  
[Ruby on Rails](#ruby-on-rails)  
[Spring](#spring)

## PostgreSQL

### Instalación

Para la **capa de datos** de las aplicaciones que vamos a desplegar, necesitamos un sistema gestor de bases de datos. Trabajaremos sobre [PostgreSQL](<[https://](https://www.postgresql.org/)>): _"The World's Most Advanced Open Source Relational Database"_.

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

postgres=# CREATE USER travelroad_user WITH ENCRYPTED PASSWORD 'travelroad_password';
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

Vamos a cargar los datos desde este fichero [places.csv](./files/places.csv):

https://raw.githubusercontent.com/sdelquin/dpl/main/ut0/github-deliver.md
