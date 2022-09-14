# Pasos posteriores a la instalación

Dar permisos de superusuario al `<usuario>` ordinario que creamos durante la instalación del sistema operativo:

```console
$ su -l
$ addgroup <usuario> sudo
```

> Salir de la sesión y volver a entrar para que los cambios surtan efecto.

Instalar editor vim:

```console
$ sudo apt install vim
```
