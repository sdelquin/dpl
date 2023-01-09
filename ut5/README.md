# UT5: Servicios de red implicados en el despliegue de una aplicación web

En el despliegue de una aplicación web pueden aparecer distintos servicios de red. El conocimiento de su naturaleza y comportamiento pueden ayudarnos a mejorar nuestros flujos de trabajo.

[FTP](#ftp)  
[SSH](#ssh)  
[DNS](#dns)  
[LDAP](#ldap)
[GitHub](#github)

## FTP

El protocolo clásico para la transferencia de archivos en Internet se denomina **FTP (File Transfer Protocol)**. Con el estado actual de Internet y las múltiples opciones de trasferencia de archivos en la web puede parecer algo innecesario pero sigue siendo una opción sencilla y específica por lo que aún se sigue utilizando en algunos ámbitos.

FTP se ajusta a una arquitectura cliente/servidor como todo lo que hemos visto hasta ahora. En Linux existen muchos servidores FTP diferentes. La elección puede ser bastante subjetiva pero nos decantamos por **vsFTPd (Very Secure FTP Daemon)** ya que es el servidor FTP por defecto en las principales distribuciones de Linux lo que lo hace más sencilla de instalar y además se considera más seguro.

### Instalación del servidor

Empezamos actualizando el listado de paquetes:

```console
sdelquin@lemon:~$ sudo apt update
Obj:1 http://security.debian.org/debian-security bullseye-security InRelease
Obj:2 http://deb.debian.org/debian bullseye InRelease
Obj:3 http://deb.debian.org/debian bullseye-updates InRelease
Obj:4 https://download.docker.com/linux/debian bullseye InRelease
Obj:5 https://packages.sury.org/php bullseye InRelease
Obj:6 http://apt.postgresql.org/pub/repos/apt bullseye-pgdg InRelease
Obj:7 http://packages.microsoft.com/repos/code stable InRelease
Obj:8 http://nginx.org/packages/debian bullseye InRelease
Obj:9 https://deb.nodesource.com/node_19.x bullseye InRelease
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Se pueden actualizar 130 paquetes. Ejecute «apt list --upgradable» para verlos.
```

Instalamos directamente el servidor vsFTPd:

```console
sdelquin@lemon:~$ sudo apt install -y vsftpd
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Se instalarán los siguientes paquetes NUEVOS:
  vsftpd
0 actualizados, 1 nuevos se instalarán, 0 para eliminar y 130 no actualizados.
Se necesita descargar 147 kB de archivos.
Se utilizarán 357 kB de espacio de disco adicional después de esta operación.
Des:1 http://deb.debian.org/debian bullseye/main arm64 vsftpd arm64 3.0.3-12 [147 kB]
Descargados 147 kB en 0s (783 kB/s)
Preconfigurando paquetes ...
Seleccionando el paquete vsftpd previamente no seleccionado.
(Leyendo la base de datos ... 236090 ficheros o directorios instalados actualmente.)
Preparando para desempaquetar .../vsftpd_3.0.3-12_arm64.deb ...
Desempaquetando vsftpd (3.0.3-12) ...
Configurando vsftpd (3.0.3-12) ...
Created symlink /etc/systemd/system/multi-user.target.wants/vsftpd.service → /lib/systemd/system/vsf
tpd.service.
Procesando disparadores para man-db (2.9.4-2) ...
```

Podemos comprobar que el servicio está instalado y corriendo:

```console
sdelquin@lemon:~$ sudo systemctl is-active vsftpd
active
```

El puerto por defecto en el que escucha un servidor FTP es el **puerto 21**. Podemos comprobarlo de la siguiente manera:

```console
sdelquin@lemon:~$ sudo netstat -napt | grep ftp
tcp6       0      0 :::21                   :::*                    LISTEN      116185/vsftpd
```

### Instalación del cliente

Existen multitud de clientes FTP (con y sin interfaz gráfica). Para el caso que nos ocupa vamos a instalar un cliente en modo consola muy sencillo:

```console
sdelquin@lemon:~$ sudo apt install -y ftp
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Se instalarán los siguientes paquetes NUEVOS:
  ftp
0 actualizados, 1 nuevos se instalarán, 0 para eliminar y 130 no actualizados.
Se necesita descargar 57,4 kB de archivos.
Se utilizarán 140 kB de espacio de disco adicional después de esta operación.
Des:1 http://deb.debian.org/debian bullseye/main arm64 ftp arm64 0.17-34.1.1 [57,4 kB]
Descargados 57,4 kB en 0s (319 kB/s)
Seleccionando el paquete ftp previamente no seleccionado.
(Leyendo la base de datos ... 236148 ficheros o directorios instalados actualmente.)
Preparando para desempaquetar .../ftp_0.17-34.1.1_arm64.deb ...
Desempaquetando ftp (0.17-34.1.1) ...
Configurando ftp (0.17-34.1.1) ...
update-alternatives: utilizando /usr/bin/netkit-ftp para proveer /usr/bin/ftp (ftp) en modo automático
Procesando disparadores para man-db (2.9.4-2) ...
```

Ahora podemos comprobar la conexión con el servidor desde la misma máquina (localhost):

```console
sdelquin@lemon:~$ ftp localhost
Connected to localhost.
220 (vsFTPd 3.0.3)
Name (localhost:sdelquin):
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
```

> 💡 Accedemos con las credenciales del usuario Linux.

Si queremos acceder "desde fuera" nos basta con especificar el nombre de dominio:

```console
$ ftp dpl.arkania.es
```

### Comandos remotos

Una vez conectados a nuestro servidor FTP, existen una serie de comandos básicos que podemos ejecutar en remoto:

| Comando | Descripción                          |
| ------- | ------------------------------------ |
| `ls`    | Listar el contenido de la carpeta    |
| `cd`    | Cambiar a otra carpeta               |
| `mkdir` | Crear una nueva carpeta              |
| `pwd`   | Mostrar la carpeta de trabajo actual |
| `get`   | Descargar el fichero especificado    |
| `mget`  | Descargar los ficheros especificados |

### Comandos locales

Aunque estemos conectados a un servidor FTP, podemos ejecutar una serie de comandos básicos en nuestra máquina local (desde la que hicimos la conexión):

| Comando | Descripción                          |
| ------- | ------------------------------------ |
| `lcd`   | Cambiar a otra carpeta               |
| `!pwd`  | Mostrar la carpeta de trabajo actual |
| `put`   | Subir el fichero especificado        |
| `mput`  | Subir los ficheros especificados     |

> 💡 Para salir de la sesión FTP usamos el comando `quit`.

### Seguridad

Aunque es posible incorporar un certificado de seguridad a las conexiones que realizamos por FTP, es mucho más cómodo utilizar directamente el protocolo SSH que ya incorpora mecanismos propios de seguridad.

## SSH

SSH (o **S**ecure **SH**ell, en español: intérprete de órdenes seguro) es el nombre de un protocolo y del programa que lo implementa cuya principal función es el acceso remoto a un servidor por medio de un canal seguro en el que toda la información está cifrada.

SSH permite **copiar datos de forma segura** (tanto archivos sueltos como simular **sesiones FTP cifradas**), **gestionar claves RSA** para no escribir contraseñas al conectar a los dispositivos y pasar los datos de cualquier otra aplicación por un canal seguro tunelizado mediante SSH y también puede redirigir el tráfico del (Sistema de Ventanas X) para poder ejecutar programas gráficos remotamente. **El puerto TCP asignado es el 22**.

SSH también funciona sobre un modelo cliente-servidor. El servidor es el programa que está escuchando peticiones en el puerto asignado mientras que el cliente es el programa que hace uso de esos servicios conectándose de forma remota a la máquina en cuestión.

### Instalación

[OpenSSH](https://www.openssh.com/) es una de las herramientas más usadas para trabajar con protocolo SSH y ofrece tanto el programa servidor como el programa cliente.

#### Servidor

Es bastante común que los sistemas base Linux ya vengan con el servidor SSH preinstalado. En cualquier caso su implantación es muy sencilla:

```console
sdelquin@lemon:~$ sudo apt install -y openssh-server
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
openssh-server ya está en su versión más reciente (1:8.4p1-5+deb11u1).
fijado openssh-server como instalado manualmente.
0 actualizados, 0 nuevos se instalarán, 0 para eliminar y 130 no actualizados.
```

Es importante tener en cuenta que, aunque el paquete se llama **openssh**, el servicio que queda corriendo es **ssh**. Podemos comprobarlo así:

```console
sdelquin@lemon:~$ sudo systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2022-12-29 10:59:22 WET; 1 weeks 3 days ago
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 543 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 858 (sshd)
      Tasks: 1 (limit: 2251)
     Memory: 3.2M
        CPU: 11ms
     CGroup: /system.slice/ssh.service
             └─858 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups

dic 29 10:59:21 lemon systemd[1]: Starting OpenBSD Secure Shell server...
dic 29 10:59:22 lemon sshd[858]: Server listening on 0.0.0.0 port 22.
dic 29 10:59:22 lemon sshd[858]: Server listening on :: port 22.
dic 29 10:59:22 lemon systemd[1]: Started OpenBSD Secure Shell server.
```

Como se ha comentado previamente, el puerto (por defecto) en el que trabaja el servidor SSH es el **puerto 22**. Esto se puede ver de la siguiente manera:

```console
sdelquin@lemon:~$ sudo netstat -napt | grep ssh | grep -v tcp6
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      858/sshd: /usr/sbin
```

#### Cliente

El cliente SSH se puede instalar igualmente de manera muy simple:

```console
sdelquin@lemon:~$ sudo apt install -y openssh-client
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
openssh-client ya está en su versión más reciente (1:8.4p1-5+deb11u1).
0 actualizados, 0 nuevos se instalarán, 0 para eliminar y 130 no actualizados.
```

Este paquete no sólo proporciona el cliente "habitual" de ssh sino otra serie de herramientas muy interesantes. Podemos identificarlas tal que así:

```console
sdelquin@lemon:~$ dpkg -L openssh-client | grep '/usr/bin/'
/usr/bin/scp
/usr/bin/sftp
/usr/bin/ssh
/usr/bin/ssh-add
/usr/bin/ssh-agent
/usr/bin/ssh-argv0
/usr/bin/ssh-copy-id
/usr/bin/ssh-keygen
/usr/bin/ssh-keyscan
/usr/bin/slogin
```

### Configuración del servidor SSH

La configuración del servidor SSH se encuentra en el fichero (privilegiado) `/etc/ssh/sshd_config` (nótese la "d" que viene de "daemon").

Algunos de los [parámetros más relevantes](https://man7.org/linux/man-pages/man5/sshd_config.5.html):

| Parámetro              | Explicación                           | Valor por defecto |
| ---------------------- | ------------------------------------- | ----------------- |
| Port                   | Puerto de escucha                     | 22                |
| PermitRootLogin        | Permitir login de root\*              | prohibit-password |
| PubkeyAuthentication   | Permitir validación con clave pública | yes               |
| PasswordAuthentication | Permitir validación con contraseña    | yes               |
| X11Forwarding          | Permitir abrir aplicaciones gráficas  | yes               |
| Banner                 | Ruta a un fichero de banner           | none              |

\*Opciones para `PermitRootLogin`:

![PermitRootLogin](./images/sshd-permitrootlogin.png)

> 💡 Tras modificar la configuración habrá que recargar el servicio para que los cambios surtan efecto.

### Herramientas cliente SSH

#### `ssh`

Permite conectar a una máquina con servidor SSH.

Ejemplos:

```console
$ ssh sdelquin@dpl.arkania.es  # conexión como sdelquin
$ ssh dpl.arkania.es           # conexión con usuario logeado
```

#### `scp`

Permite copiar desde/hacia una máquina con servidor SSH.

Ejemplos:

```console
$ scp image.jpg sdelquin@dpl.arkania.es       # destino $HOME (remoto)
$ scp image.jpg dpl.arkania.es                # usa usuario logeado
$ scp image.jpg dpl.arkania.es:~/images       # destino $HOME/images (remoto)
$ scp dpl.arkania.es:~/images/image.jpg .     # destino carpeta actual (local)
$ scp dpl.arkania.es:~/images/image.jpg /tmp  # destino /tmp (local)
$ scp -r dpl.arkania.es:~/images .            # copia de carpeta completa
```

#### `sftp`

Esta herramienta es análoga a `scp` pero permite un **manejo interactivo**:

```console
$ sftp dpl.arkania.es
Connected to arkania.
sftp>
```

Comandos disponibles **en remoto**:

| Comando | Descripción                                |
| ------- | ------------------------------------------ |
| `cd`    | Cambiar directorio                         |
| `chgrp` | Cambiar grupo a fichero                    |
| `chmod` | Cambiar permisos a fichero                 |
| `chown` | Cambiar propietario a fichero              |
| `df`    | Estadísticas de uso del disco              |
| `get`   | Descargar un fichero o una carpeta (`-r`)  |
| `ls`    | Listar el contenido de la carpeta actual   |
| `mkdir` | Crear una nueva carpeta                    |
| `pwd`   | Mostrar la carpeta de trabajo              |
| `rm`    | Borrar un fichero                          |
| `rmdir` | Borrar una carpeta (tiene que estar vacía) |

Comandos disponibles **en local**:

| Comando  | Descripción                              |
| -------- | ---------------------------------------- |
| `lcd`    | Cambiar directorio                       |
| `lls`    | Listar el contenido de la carpeta actual |
| `lmkdir` | Crear una nueva carpeta                  |
| `lpwd`   | Mostrar la carpeta de trabajo            |
| `!<cmd>` | Ejecuta cualquier comando (en local)     |

> 💡 Es una especie de FTP "vitaminado" y con comunicaciones cifradas.

#### `ssh-keygen`

Permite generar un par de claves pública/privada para el acceso a una máquina con servidor SSH.

Para su uso basta con ejecutarlo de la siguiente manera:

```console
sdelquin@lemon:~$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/sdelquin/.ssh/id_rsa):
Created directory '/home/sdelquin/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/sdelquin/.ssh/id_rsa
Your public key has been saved in /home/sdelquin/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:1qlC4/7+tEcRKSZs9YYqzj9FIqLFwTITfjjsguemzUg sdelquin@lemon
The key's randomart image is:
+---[RSA 3072]----+
|  .o   . ..  .   |
| o+.o   + ooo    |
|  ==.. . o..o.   |
|.. o+ . .o.o.    |
|o oo .+.Soo  .   |
| +.  = + .. .    |
| Eo   = ....     |
|.*   . o.. ..    |
|o o   .o+oo.     |
+----[SHA256]-----+
```

→ RSA es un tipo de algoritmo para generar claves, pero existen [otros algoritmos de generación de claves](https://goteleport.com/blog/comparing-ssh-keys/).

Con el comando anterior se habrá creado una carpeta `$HOME/.ssh` con las claves:

```console
sdelquin@lemon:~$ ls -l .ssh/
total 8
-rw------- 1 sdelquin sdelquin 2602 ene  9 12:18 id_rsa      # clave privada
-rw-r--r-- 1 sdelquin sdelquin  568 ene  9 12:18 id_rsa.pub  # clave pública
```

#### `ssh-copy-id`

Permite copiar la clave pública (generada con `ssh-keygen`) a la máquina con servidor SSH con el objetivo de poder "logearnos" sin necesidad de introducir contraseña.

```console
sdelquin@lemon:~$ ssh-copy-id dpl.arkania.es
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/sdelquin/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
sdelquin@dpl.arkania.es's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'dpl.arkania.es'"
and check to make sure that only the key(s) you wanted were added.
```

Ahora ya podemos acceder por ssh a la máquina remota sin necesidad de usar claves "en línea":

```console
sdelquin@lemon:~$ ssh dpl.arkania.es
Linux vps-fc1b46ec 5.10.0-19-cloud-amd64 #1 SMP Debian 5.10.149-2 (2022-10-21) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Wed Nov  2 16:21:14 2022 from 193.146.93.24
sdelquin@vps-fc1b46ec:~$
```

## DNS

El **sistema de nombres de dominio** (Domain Name System o **DNS**, por sus siglas en inglés)​ es un sistema de nomenclatura **jerárquico** y **distribuido** para dispositivos conectados a redes IP como Internet o una red privada. Su función más importante es "traducir" nombres inteligibles para las personas en identificadores binarios asociados con los equipos conectados a la red, esto con el propósito de poder localizar y direccionar estos equipos mundialmente.

### Procedimiento de resolución

En el siguiente esquema se visualiza el procedimiento de resolución de nombres de dominio:

![DNS](./images/dns.svg)

| Elemento                        | Descripción                                                      |
| ------------------------------- | ---------------------------------------------------------------- |
| ISP                             | Internet Service Provider                                        |
| Resolver                        | Servidor de resolución de nombres del ISP                        |
| Servidor Raíz                   | Servidor de resolución de nombres de nivel 0                     |
| Servidor TLD                    | Servidor de resolución de nombres de nivel 1 (Top Level Domains) |
| Servidor de nombres autoritario | Servidor de resolución de nombres de nivel 2                     |

Para saber la IP de una máquina podemos usar el comando `host`:

```console
$ host www.google.com
www.google.com has address 142.250.200.132
www.google.com has IPv6 address 2a00:1450:4003:80f::2004
```

> 💡 Este comando, al igual que otros relativos a DNS, se encuentran en el paquete **dnsutils**.

### Registros de recursos

Para que todo el sistema de resolución de nombres de dominio funcione correctamente, la información debe estar organizada en una base de datos mediante registros de recursos.

Estos registros pueden ser de distinto tipo. En la siguiente tabla se muestra algunos de los más relevantes:

| Tipo de registro | Significado                                                                                                                                                                |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A                | Dirección (_address_). Este registro se usa para traducir nombres de servidores de alojamiento a direcciones IPv4.                                                         |
| CNAME            | Nombre canónico (_canonical Name_). Se usa para crear nombres de servidores de alojamiento adicionales, o alias, para los servidores de alojamiento de un dominio.         |
| NS               | Servidor de nombres (_name server_). Define la asociación que existe entre un nombre de dominio y los servidores de nombres que almacenan la información de dicho dominio. |
| MX               | Intercambio de correo (_mail exchange_). Asocia un nombre de dominio a una lista de servidores de intercambio de correo para ese dominio.                                  |

Veamos algunos ejemplos con nombres de dominio reales:

**Registros A**:

```console
sdelquin@lemon:~$ host -t a bloomberg.com
bloomberg.com has address 3.33.146.110
bloomberg.com has address 15.197.146.156
```

> 💡 Cuando hay más de una dirección IP se van devolviendo en función de la carga y utilizando lo que se conoce como [DNS Round Robin](https://es.wikipedia.org/wiki/Dns_round_robin).

**Registros CNAME**:

```console
sdelquin@lemon:~$ host -t cname pages.github.com
pages.github.com is an alias for github.github.io.
```

**Registros NS**:

```console
sdelquin@lemon:~$ host -t ns google.com
google.com name server ns1.google.com.
google.com name server ns3.google.com.
google.com name server ns2.google.com.
google.com name server ns4.google.com.
```

**Registros MX**:

```console
sdelquin@lemon:~$ host -t mx linux.org
linux.org mail is handled by 10 mx1.improvmx.com.
linux.org mail is handled by 20 mx2.improvmx.com.
```

### Adquirir un nombre de dominio

De cara al **despliegue de una aplicación web** es casi imprescindible **adquirir un nombre de dominio**, salvo que queramos dar al cliente una IP en formato X.X.X.X 😅

Los nombres de dominio se pueden comprar en multitud de empresas que ofrecen estos servicios. Un ejemplo es [dondominio.com](https://dondominio.com).

Aunque los precios pueden variar, suele ser un servicio relativamente barato. Un dominio `.es` está en torno a 7€ anuales.

Una vez que hayamos comprado nuestro flamante nombre de dominio, debemos entrar a gestionar la **Zona DNS** y añadir, al menos, un **registro tipo A** donde hacer apuntar el nombre de dominio a la IP de la máquina que dispone de los servicios (servidor SSH, servidor WEB, base de datos, etc.)

> 💡 Es posible usar "wildcards" en los registros DNS para asignar todos los subdominios de un dominio. Por ejemplo: `*.arkania.es`

## LDAP

## GitHub
