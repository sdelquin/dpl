# UT3-TE1: Administración de servidores web

### TAREA EVALUABLE

El objetivo de esta tarea es desplegar una aplicación web escrita en **HTML/Javascript** que permita hacer uso del módulo de Nginx **ngx_small_light**.

Este módulo sirve para generar "miniaturas" de imágenes _on the fly_ además de otros posibles procesamientos a través de peticiones URL.

Para ello se pide:

1. Instalar el módulo [ngx_small_light](https://github.com/cubicdaiya/ngx_small_light) y cargarlo dinámicamente en Nginx.
2. Crear un _virtual host_ específico que atienda peticiones en el dominio https://images.aluXXXX.arkania.es.
3. Subir las imágenes de [images.zip](./files/images.zip) a una carpeta `img` dentro de la carpeta de trabajo elegida.
4. Crear una aplicación web que permita el tratamiento de dichas imágenes.
5. Incorporar certificado de seguridad SSL.
6. Redirigir el subdominio `www` al dominio base (incluyendo ssl).

## Aplicación web

La aplicación debe contener un formulario web con los siguientes campos de texto:

- Tamaño de la imagen → En píxeles
- Ancho del borde → En píxeles
- Color del borde → Formato hexadecimal
- Enfoque → Formato `<radius>x<sigma>`
- Desenfoque → Formato `<radius>x<sigma>`

Al pulsar el botón de "Generar" se tendrán que mostrar todas las imágenes cambiando la URL del atributo `src` de cada imagen `<img>` para contemplar los parámetros establecidos en el formulario.

![UT3-TE1 Mockup](./images/ut3-te1_mockup.jpg)

**Notas a tener en cuenta**:

- Las dependencias previas del módulo ngx_small_light se resuelven con: `sudo apt install imagemagick libpcre3 libpcre3-dev`

- Se puede presuponer que siempre van a haber 20 imágenes con los nombres `image01.jpg`, `image02.jpg`, ...
- Usar [peticiones GET del módulo ngx_small_light](https://github.com/cubicdaiya/ngx_small_light#using-get-parameters) para el tratamiento de las imágenes.
- Trabajar en una carpeta dentro del `$HOME`.

## Entregable

Informe explicando los pasos seguidos para resolver la tarea.

> Subir únicamente la URL al commit del repositorio:  
> `https://github.com/<user>/dpl/blob/ffaabb62206fa0c0f350dfe0a4ba370ed00b9218/ut<X>/te<X>/README.md`
