# Arkania

El alumnado dispondrá de una máquina remota (VPS: Virtual Private Server) alojada en [OVHcloud](https://www.ovhcloud.com/es-es/) con la que trabajar de una forma más "real" para un entorno de producción.

Esta máquina tiene las siguientes características:

| Recurso | Cantidad |
| ------- | -------- |
| CPU     | 1vCPU    |
| RAM     | 2GB      |
| SSD     | 30GB     |

## Acceso

El alumnado recibirá una "tarjeta" con los siguientes datos de acceso:

- Nombre y apellidos.
- Nombre de la máquina (`aluXXXX.arkania.es`)
- Usuario.
- Contraseña.

`aluXXXX` contendrá el número de expediente de cada alumno/a, un valor único que les identifica en el centro educativo. Suele ser un número de 4 dígitos.

El usuario tendrá permisos como "sudoer".

## Primeros pasos

Una vez que nos conectemos por primera vez a la máquina vía ssh, tendremos que realizar algunos pasos:

```console
$ sudo -s
$ adduser <usuario>  # 🚨 ¡No olvides la contraseña!
$ addgroup <usuario> sudo
$ exit
$ exit
```

Volvemos a conectar por ssh pero ya usando el nuevo usuario que hemos creado. Ejecutamos los comandos restantes:

```console
$ sudo deluser debian
$ sudo rm -fr /home/debian/
$ sudo apt update
$ sudo apt upgrade
$ sudo reboot
```

> 💡 Sustituye `<usuario>` por el nombre de usuario que suelas utilizar. Preferiblemente el mismo con el que trabajas en la máquina virtual de clase.

🚨 No olvides la contraseña de acceso que has asignado a tu nueva cuenta.

## Acceso con clave pública/privada

Con el objetivo de mejorar la seguridad de la máquina remota, vamos a acceder únicamente por ssh con clave pública/privada.

Lo primero será generar el par de claves de cifrado **desde la máquina virtual (local)**:

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

Ahora podemos utilizar la utilidad `ssh-copy-id` para copiar nuestra **clave pública** a la máquina remota. **Desde la máquina virtual (local)** ejecutamos lo siguiente:

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

## Importante

1. La máquina **sólo se podrá usar para fines académicos** dentro del ámbito educativo del ciclo formativo cursado en el IES Puerto de la Cruz - Telesforo Bravo.
2. Si se detectara cualquier otro contenido fuera del ámbito educativo o cualquier **contenido inapropiado se procederá al cierre inmediato** de la máquina remota.
