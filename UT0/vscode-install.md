# Visual Studio Code

## Instalación

Creamos una carpeta temporal y descargamos la última versión disponible de VSCode:

```console
$ curl "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -Lo /tmp/vscode.deb
```

Comprobamos que el paquete se haya descargado correctamente:

```console
$ file /tmp/vscode.deb
vscode.deb: Debian binary package (format 2.0), with control.tar.xz, data compression xz
```

Instalamos el paquete:

```console
$ sudo apt install /tmp/vscode.deb
...
```

Comprobamos que la instalación ha sido satisfactoria:

```console
$ code --version
1.71.1
e7f30e38c5a4efafeec8ad52861eb772a9ee4dfb
amd64
```

> Es posible que tengas pequeñas diferencias en la versión. ¡No te preocupes!
