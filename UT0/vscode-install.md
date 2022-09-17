# Visual Studio Code

## Instalación

Creamos una carpeta temporal y descargamos la última versión disponible de VSCode:

```console
$ cd /tmp
$ wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O vscode.deb
```

Instalamos el paquete:

```console
$ sudo apt install ./vscode.deb
...
```

Comprobamos que la instalación ha sido satisfactoria:

```console
$ code --version
1.71.1
e7f30e38c5a4efafeec8ad52861eb772a9ee4dfb
amd64
```
