# UT3-TE1: Administración de servidores web

### TAREA EVALUABLE

El objetivo de esta tarea es desplegar una aplicación web escrita en **HTML/Javascript** que permita hacer uso del módulo de Nginx **ngx_small_light**.

Este módulo sirve para generar "miniaturas" de imágenes _on the fly_ además de otros posibles procesamientos a través de peticiones URL.

Para ello se pide:

1. Instalar el módulo [ngx_small_light](https://github.com/cubicdaiya/ngx_small_light) y cargarlo dinámicamente en Nginx.
2. Crear un _virtual host_ específico que atienda peticiones en el dominio https://images.aluXXXX.arkania.es.
3. Subir las imágenes de [images.zip](./files/images.zip) a una carpeta `img` dentro de la carpeta de trabajo elegida.
4. Crear una aplicación web que permita el tratamiento de dichas imágenes.
5. Incorporar certificado de seguridad (mostrar el certificado 🔒).
6. Redirigir el subdominio `www` al dominio base (incluyendo ssl).

## Módulo ngx_small_light

Para la instalación del módulo [seguir las instrucciones de instalación de módulos](../README.md#instalación-de-un-módulo), teniendo en cuenta que:

1. Hay que instalar las siguientes dependencias:

```
sudo apt install -y build-essential imagemagick libpcre3 libpcre3-dev libmagickwand-dev
```

2. Hay que descargar el código fuente del módulo con:

```console
git clone https://github.com/cubicdaiya/ngx_small_light.git
```

3. Hay que "configurar" el módulo, previo a la configuración de Nginx, entrando en la carpeta del módulo y ejecutando:

```console
./setup
```

## Aplicación web

La aplicación debe contener un formulario web con los siguientes campos de texto:

- Tamaño de la imagen → En píxeles (corresponde al "lado": son imágenes cuadradas)
- Ancho del borde → En píxeles
- Color del borde → Formato hexadecimal
- Enfoque → Formato `<radius>x<sigma>`
- Desenfoque → Formato `<radius>x<sigma>`

Al pulsar el botón de "Generar" se tendrán que mostrar todas las imágenes cambiando la URL del atributo `src` de cada imagen `<img>` para contemplar los parámetros establecidos en el formulario.

![UT3-TE1 Mockup](./images/ut3-te1_mockup.jpg)

**Notas a tener en cuenta**:

- Se puede presuponer que siempre van a haber **20 imágenes** con los nombres `image01.jpg`, `image02.jpg`, ... y que las **imágenes son cuadradas**.
- Usar [peticiones GET del módulo ngx_small_light](https://github.com/cubicdaiya/ngx_small_light#using-get-parameters) para el tratamiento de las imágenes, modificando el atributo `src` de cada `<img>`.
- Trabajar en una carpeta dentro del `$HOME`.

## Entregable

Informe explicando los pasos seguidos para resolver la tarea.

⚡ Revisa las [instrucciones sobre entrega de tareas](../../ut0/assignment-deliveries.md).
