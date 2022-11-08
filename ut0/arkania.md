# Arkania

[Arkania](https://starwars.fandom.com/es/wiki/Arkania/Leyendas) forma parte del **Universo StarWars**. Era el planeta adoptivo de la raza arkaniana. Estaba cubierto de tundras y era rico en diamantes y otros minerales preciosos, que los arkanianos extraían para incrementar sus conexiones en otros mundos y dominar su tecnología.

![Arkania](./images/arkania.jpg)

## VPS

El alumnado dispondrá de una máquina remota ([VPS: Virtual Private Server](https://es.wikipedia.org/wiki/Servidor_virtual_privado)) alojada en [OVHcloud](https://www.ovhcloud.com/es-es/) con la que trabajar de una forma más "real" para un entorno de producción.

Esta máquina tiene las siguientes características:

| Recurso | Cantidad  |
| ------- | --------- |
| CPU     | 1vCPU     |
| RAM     | 2GB       |
| SSD     | 30GB      |
| S.O.    | Debian 11 |

> 💡 Para diferenciar, hablaremos de **máquina local** para la máquina virtual que se ha montado localmente en el puesto de cada alumno/a, y hablaremos de **máquina remota** para la máquina alojada en el servicio cloud mediante un VPS.

## Acceso

El alumnado recibirá una "tarjeta" con los siguientes datos de acceso a la máquina remota:

- Nombre y apellidos.
- Nombre de la máquina (`aluXXXX.arkania.es`)
- Usuario (`debian`).
- Contraseña.

`aluXXXX` contendrá el número de expediente de cada alumno/a, un valor único que les identifica unívocamente dentro del centro educativo. Suele ser un número de 4 dígitos.

El usuario `debian` tendrá permisos como "sudoer".

## Primeros pasos

Para conectarnos por primera vez, debemos lanzar una **conexión ssh desde la máquina local**:

```console
$ ssh debian@aluXXXX.arkania.es
The authenticity of host 'aluXXXX.arkania.es (X.X.X.X)' can't be established.
ECDSA key fingerprint is SHA256:7394hjh3h0932lnklfnsd908432.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
```

> 💡 Respondemos "yes" a la pregunta si conectar a la máquina a pesar de que la autenticidad del host no puede ser establecida.

Una vez conectados a la máquina remota nos interesa crear un usuario "ordinario" para el trabajo de clase:

```console
$ sudo -s  # ingresar como "root"

$ adduser <usuario>  # 🚨 ¡No olvides la contraseña!
Adding user `<usuario>' ...
Adding new group `<usuario>' (1000) ...
Adding new user `<usuario>' (1000) with group `<usuario>' ...
Creating home directory `/home/<usuario>' ...
Copying files from `/etc/skel' ...
New password:
Retype new password:
passwd: password updated successfully
Changing the user information for sergio
Enter the new value, or press ENTER for the default
	Full Name []: Sergio Delgado Quintero
	Room Number []:
	Work Phone []:
	Home Phone []:
	Other []:
Is the information correct? [Y/n]

$ addgroup <usuario> sudo

$ exit
$ exit
```

> 💡 Sustituye `<usuario>` por el nombre de usuario que suelas utilizar. Preferiblemente el mismo con el que trabajas en la máquina virtual de clase.

🚨 No olvides la contraseña de acceso que has asignado a tu nueva cuenta.

Ahora, ya **desde la máquina local**, volvemos a conectarnos a la máquina remota sin necesidad de indicar usuario, ya que por defecto toma el usuario actual (que debería ser el mismo que hemos creado en la máquina remota):

```console
$ ssh aluXXXX.arkania.es
```

Realizamos algunos pasos más: borrar el usuario original `debian` y actualizar el sistema:

```console
$ sudo deluser debian
$ sudo rm -fr /home/debian/
$ sudo apt update
$ sudo apt upgrade
$ sudo reboot
```

En este momento la máquina se reiniciará y nos "sacará" de la sesión ssh. Espera 1 minuto aproximadamente y vuelve a probar el acceso por ssh. Todo debería ir bien 🤞.

## Acceso con clave pública/privada

Por facilidad a la hora de conectarnos a la máquina remota, vamos a acceder mediante ssh con [autenticación de clave pública](<[https://](https://www.ssh.com/academy/ssh/public-key-authentication)>).

Lo primero será generar el par de claves de cifrado **desde la máquina local**:

```console
sdelquin@lemon:~$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/sdelquin/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/sdelquin/.ssh/id_rsa
Your public key has been saved in /home/sdelquin/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:+wIYHdc77XkzocUWDQOxOq3KQDiqMeVesJxScN1xXtU sdelquin@lemon
The key's randomart image is:
+---[RSA 3072]----+
|      . ....++oo |
|   . ..+...  .E..|
|. . ...o.  o.. . |
| o  ...   oo. =  |
|  + oo. S oo.= . |
| = =.o.  . o+ +  |
|+ * . ... .  . o |
| * .   o.o       |
|. .     o..      |
+----[SHA256]-----+
```

> 💡 Puedes pulsar <kbd>ENTER</kbd> para todas las preguntas que se hagan dejando los valores por defecto.

El comando anterior habrá creado un par de claves ssh (pública/privada) en tu `HOME`:

```console
sdelquin@lemon:~$ tree .ssh/
.ssh/
├── id_rsa
└── id_rsa.pub

0 directories, 2 files
```

Ahora podemos utilizar la utilidad `ssh-copy-id` para copiar nuestra **clave pública** a la máquina remota. **Desde la máquina local** ejecutamos lo siguiente:

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

Ahora ya podemos **acceder por ssh a la máquina remota** sin necesidad de usar claves "en línea":

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

### Mejorando la seguridad (OPCIONAL)

🚨 **SOLO SI HAS COMPROBADO QUE TU ACCESO CON CLAVE PÚBLICA FUNCIONA CORRECTAMENTE** 🚨 podrías mejorar la seguridad de tu máquina **deshabilitando la autenticación con contraseña**.

Desde la máquina remota, ejecuta el siguiente comando:

```console
sdelquin@vps-fc1b46ec:~$ sudo vi /etc/ssh/sshd_config
```

Modifica la siguiente línea:

```
58 | PasswordAuthentication no
```

Y recarga el servicio ssh:

```console
sdelquin@vps-fc1b46ec:~$ sudo systemctl reload sshd
```

Salimos de la máquina remota. Ahora podemos comprobar, **desde la máquina local**, que los accesos utilizando usuario/contraseña ya no están permitidos, o dicho de otra forma, que **sólo se permite el acceso por clave pública**, y que el usuario con el que estamos tratando de entrar no tiene registrada una clave pública en la máquina remota:

```console
sdelquin@lemon:~$ ssh torvalds@dpl.arkania.es
torvalds@dpl.arkania.es: Permission denied (publickey).
```

#### Un puerto diferente

Para aquellas personas muy preocupadas por la seguridad, existe otro paso más. Consiste en **cambiar el puerto** que utilizamos para conectarnos por ssh.

En vez del típico puerto 22, vamos a modificarlo por el puerto 2222. Para ello, **desde la máquina remota**, ejecutamos lo siguiente:

```console
sdelquin@vps-fc1b46ec:~$ sudo vi /etc/ssh/sshd_config
```

Modifica la siguiente línea:

```
15 | Port 2222
```

Y recarga el servicio ssh:

```console
sdelquin@vps-fc1b46ec:~$ sudo systemctl reload sshd
```

Salimos de la máquina remota. Ahora podemos comprobar, **desde la máquina local** que el acceso por el puerto habitual (por defecto el puerto 22) ya no funciona:

```console
sdelquin@lemon:~$ ssh dpl.arkania.es
ssh: connect to host dpl.arkania.es port 22: Connection refused
```

Para poder acceder a la máquina remota, debemos hacerlo modificando el puerto al 2222:

```console
sdelquin@lemon:~$ ssh -p2222 dpl.arkania.es
Linux vps-fc1b46ec 5.10.0-19-cloud-amd64 #1 SMP Debian 5.10.149-2 (2022-10-21) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Thu Nov  3 10:43:27 2022 from 88.8.15.135
```

### Acceso rápido

Para no tener que estar escribiendo continuamente el nombre completo de dominio `aluXXXX.arkania.es` podemos hacer uso del fichero `~/.ssh/config` y definir ciertos "alias".

Lo primero será obtener la IP de nuestra máquina remota. Para ello, **desde la máquina local** ejecutamos:

```console
sdelquin@lemon:~$ host dpl.arkania.es
dpl.arkania.es has address 193.70.86.26
```

> ⚠️ Recuerda usar tu nombre de dominio.

Ahora ya podemos crear el fichero de configuración ssh:

```console
sdelquin@lemon:~$ vi ~/.ssh/config
```

> Contenido:

```
Host "arkania"
    Hostname "193.70.86.26"
    Port 2222
```

Esto nos permite acceder a la máquina remota simplemente con:

```console
sdelquin@lemon:~$ ssh arkania
Linux vps-fc1b46ec 5.10.0-19-cloud-amd64 #1 SMP Debian 5.10.149-2 (2022-10-21) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Thu Nov  3 11:03:36 2022 from 88.8.15.135
```

## Pasos posteriores a la instalación

Es posible que haya ciertos [pasos posteriores a la instalación](https://github.com/sdelquin/pro/blob/main/ut0/post-install.md) que te interese añadir a la configuración de tu nueva máquina remota.

Por cierto, ¿te has parado a pensar cuánta RAM estamos usando en nuestra máquina remota? Ejecuta `free -m` y fíjate en la columna `used`. ¡Muy poco! 👏

## ✋ Importante

1. La máquina **sólo se podrá usar para fines académicos** dentro del ámbito educativo del ciclo formativo cursado en el IES Puerto de la Cruz - Telesforo Bravo.
2. Si se detectara cualquier otro contenido fuera del ámbito educativo o cualquier **contenido inapropiado se procederá al cierre inmediato** de la máquina remota.
