# Docker

![Docker](files/docker.png)

## Pasos previos

Instalamos ciertos prerrequisitos:

```console
sdelquin@lemon:~$ sudo apt-get update
sdelquin@lemon:~$ sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

Importamos la clave GPG del repositorio externo de Docker:

```console
sdelquin@lemon:~$ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg
```

Añadimos el respositorio externo de Docker:

```console
sdelquin@lemon:~$ echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

## Instalación

Actualizamos la lista de fuentes de paquetes:

```console
sdelquin@lemon:~$ sudo apt update
Obj:1 http://security.debian.org/debian-security bullseye-security InRelease
Obj:2 http://deb.debian.org/debian bullseye InRelease
Obj:3 http://deb.debian.org/debian bullseye-updates InRelease
Des:4 https://download.docker.com/linux/debian bullseye InRelease [43,3 kB]
Obj:5 http://packages.microsoft.com/repos/code stable InRelease
Des:6 https://download.docker.com/linux/debian bullseye/stable arm64 Packages [11,7 kB]
Obj:7 https://packages.sury.org/php bullseye InRelease
Descargados 55,1 kB en 1s (78,6 kB/s)
Leyendo lista de paquetes... Hecho
Creando árbol de dependencias... Hecho
Leyendo la información de estado... Hecho
Todos los paquetes están actualizados.
```

Ahora sí podemos instalar ya las herramientas Docker en el sistema:

```console
sdelquin@lemon:~$ sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
...
...
...
```

## Comprobación

Lo primero de todo es comprobar que el servicio esté corriendo correctamente:

```console
sdelquin@lemon:~$ sudo systemctl status docker
● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2022-09-16 12:45:28 WEST; 2min 25s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 86331 (dockerd)
      Tasks: 8
     Memory: 35.0M
        CPU: 117ms
     CGroup: /system.slice/docker.service
             └─86331 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

sep 16 12:45:28 lemon dockerd[86331]: time="2022-09-16T12:45:28.032847201+01:00" level=info msg="scheme \"un>
sep 16 12:45:28 lemon dockerd[86331]: time="2022-09-16T12:45:28.032854909+01:00" level=info msg="ccResolverW>
sep 16 12:45:28 lemon dockerd[86331]: time="2022-09-16T12:45:28.032893575+01:00" level=info msg="ClientConn >
sep 16 12:45:28 lemon dockerd[86331]: time="2022-09-16T12:45:28.073261246+01:00" level=info msg="Loading con>
sep 16 12:45:28 lemon dockerd[86331]: time="2022-09-16T12:45:28.154568955+01:00" level=info msg="Default bri>
sep 16 12:45:28 lemon dockerd[86331]: time="2022-09-16T12:45:28.199050947+01:00" level=info msg="Loading con>
sep 16 12:45:28 lemon dockerd[86331]: time="2022-09-16T12:45:28.226591830+01:00" level=info msg="Docker daem>
sep 16 12:45:28 lemon dockerd[86331]: time="2022-09-16T12:45:28.226646621+01:00" level=info msg="Daemon has >
sep 16 12:45:28 lemon systemd[1]: Started Docker Application Container Engine.
sep 16 12:45:28 lemon dockerd[86331]: time="2022-09-16T12:45:28.235165174+01:00" level=info msg="API listen >
```

Igualmente podemos comprobar la versión instalada:

```console
sdelquin@lemon:~$ docker --version
Docker version 20.10.18, build b40c2f6
```

## Pasos posteriores

Un usuario "ordinario" no podría trabajar con Docker ya que el servicio sólo está a disposición de usuarios "privilegiados" (`root`). En este sentido debemos incluir a nuestro usuario habitual en el grupo adecuado:

```console
sdelquin@lemon:~$ sudo usermod -aG docker $USER
```

> Para que los cambios surtan efecto, salimos de la sesión y volvemos a entrar con nuestro usuario habitual.

## Primer contenedor

Docker nos ofrece un "Hello World" para probar que todo se ha instalado correctamente y que los permisos son los adecuados:

```console
sdelquin@lemon:~$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
7050e35b49f5: Pull complete
Digest: sha256:62af9efd515a25f84961b70f973a798d2eca956b1b2b026d0a4a63a3b0b6a3f2
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (arm64v8)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

## Manejando los procesos

Cuando un contenedor está funcionando, existe un proceso dentro de Docker que lo gestiona. Podemos **ver los procesos activos** usando:

```console
sdelquin@lemon:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

Incluso podemos ver los procesos ya finalizados:

```console
sdelquin@lemon:~$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED         STATUS                     PORTS     NAMES
6dcc89f90f61   hello-world   "/hello"   2 minutes ago   Exited (0) 2 minutes ago             kind_kowalevski
```

Para **matar un proceso** podemos usar su ID o bien su nombre (que se genera aleatoriamente si no aportamos uno):

```console
sdelquin@lemon:~$ docker rm 6dcc89f90f61
6dcc89f90f61
sdelquin@lemon:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

## Manejando las imágenes

Cuando lanzamos un contenedor, su imagen debe ser previamente descargada a nuestro disco. Por ejemplo, para la aplicación anterior `hello-world`, su imagen se ha guardado localmente.

Podemos **ver las imágenes almacenadas** en nuestro disco:

```console
sdelquin@lemon:~$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
hello-world   latest    46331d942d63   6 months ago   9.14kB
```

Para **borrar una imagen** podemos usar su ID o bien su nombre:

```console
sdelquin@lemon:~$ docker rmi 46331d942d63
Untagged: hello-world:latest
Untagged: hello-world@sha256:62af9efd515a25f84961b70f973a798d2eca956b1b2b026d0a4a63a3b0b6a3f2
Deleted: sha256:46331d942d6350436f64e614d75725f6de3bb5c63e266e236e04389820a234c4
Deleted: sha256:efb53921da3394806160641b72a2cbd34ca1a9a8345ac670a85a04ad3d0e3507
sdelquin@lemon:~$ docker images
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
```

Como se comentó previamente, el lanzamiento de un contenedor implica la descarga de su imagen. Pero también es posible únicamente **descargar una imagen**:

```console
sdelquin@lemon:~$ docker pull hello-world
Using default tag: latest
latest: Pulling from library/hello-world
7050e35b49f5: Pull complete
Digest: sha256:62af9efd515a25f84961b70f973a798d2eca956b1b2b026d0a4a63a3b0b6a3f2
Status: Downloaded newer image for hello-world:latest
docker.io/library/hello-world:latest
```

Ahora ya lo tenemos disponible en el listado de imágenes locales:

```console
sdelquin@lemon:~$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
hello-world   latest    46331d942d63   6 months ago   9.14kB
```

## Limpiando recursos

Hay un paquete muy interesante de cara a la "limpieza" de recursos Docker. Se llama `docker-clean` y se puede instalar de la siguiente manera:

```console
sdelquin@lemon:~$ sudo apt install -y docker-clean
...
...
```

Uno de los comandos más cómodos es: `docker-clean run` que se encarga de borrar:

- Todos los contenedores parados.
- Todas las imágenes sin etiquetar.
- Todos las volúmenes sin usar.
- Todas las redes virtuales.
