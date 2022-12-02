# UT4-TE1: Administración de servidores web (PostgreSQL)

### TAREA EVALUABLE

El objetivo de esta tarea es preparar la infraestructura de la capa de datos para el resto de la unidad. En este sentido se va a trabajar con PostgreSQL.

## PostgreSQL

1. Instale **PostgreSQL** tanto en la máquina local (desarrollo) como en la máquina remota (producción) utilizando credenciales distintas.
2. Cargue los [datos de prueba para la aplicación TravelRoad](../README.md#carga-de-datos) tanto en desarrollo como en producción.
3. Instale **pgAdmin** tanto en desarrollo como en producción. Para desarrollo use el dominio `pgadmin.local` y para producción use el dominio `pgadmin.aluXXXX.arkania.es`. Utilice credenciales distintas y añada certificado de seguridad en la máquina de producción.
4. Acceda a **pgAdmin** y conecte un nuevo servidor **TravelRoad** con las credenciales aportadas, tanto en desarrollo como en producción.

> 💡 Incluya en el informe la URL donde está desplegado pgAdmin y las credenciales de acceso.

## Aplicación PHP

### Entorno de desarrollo

1. Instale `sudo apt install -y php8.2-pgsql` para tener disponible la función [pg_connect](https://www.php.net/manual/es/function.pg-connect.php).
2. Desarrolle en local una aplicación PHP que se encargue de mostrar los datos de [TravelRoad](../README.md#travelroad) tal y como se ha visto en clase, atacando a la base de datos local.
3. Utilice control de versiones para alojar la aplicación dentro del repositorio: `dpl/ut3/te1`
4. Use el dominio `php.travelroad.local` para montar la aplicación en el entorno de desarrollo.
5. Utilice [include](https://www.php.net/manual/en/function.include.php) en su código para incluir el fichero `config.php` que contendrá los datos de acceso a la base de datos y que **no deberá incluirse en el control de versiones**.

> 💡 Incluya en el informe el enlace al código fuente de la aplicación.

### Entorno de producción

1. Clone el repositorio en la máquina de producción.
2. Incluya el fichero `config.php` con las credenciales de acceso a la base de datos de producción.
3. Configure un _virtual host_ en producción para servir la aplicación PHP en el dominio `php.travelroad.aluXXXX.arkania.es`.
4. Incluya certificado de seguridad y redirección `www`.

> 💡 Incluya en el informe la URL donde está desplegada la aplicación.

## Despliegue

1. Cree un shell-script `deploy.sh` (con permisos de ejecución) en la carpeta de trabajo del repositorio, que se conecte por ssh a la máquina de producción y ejecute un `git pull` para actualizar los cambios.
2. Pruebe este script tras haber realizado algún cambio en la aplicación.

## Entregable

Informe explicando los pasos seguidos para resolver la tarea.

⚡ Revisa las [instrucciones sobre entrega de tareas](../../ut0/assignment-deliveries.md).
