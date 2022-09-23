# UT1-A1: Trabajando con git

1. El alumnado trabajará por parejas: `alu1` y `alu2`
2. `alu1` creará un repositorio público **git-work** en su cuenta de GitHub, añadiendo un `README.md` y una licencia MIT.
3. `alu1` clonará el repo y añadirá los ficheros: [index.html](./files/index.html), [bootstrap.min.css](./files/bootstrap.min.css) y [cover.css](./files/cover.css). Luego subirá los cambios al _upstream_.
4. `alu2` creará un fork de **git-work** desde su cuenta de GitHub.
5. `alu2` clonará su fork del repo.
6. `alu2` creará una nueva rama `custom-text` y modificará el fichero `index.html` personalizándolo para una supuesta startup.
7. `alu2` enviará un PR a `alu1`.
8. `alu1` probará el PR de `alu2` en su máquina, y propondrá ciertos cambios que deberá subir al propio PR.
9. `alu1` y `alu2` tendrán una pequeña conversación en la página del PR, incluso pudiendo añadir más cambios si fuera necesario.
10. `alu1` finalmente aprobará el PR y lo incluirá en la rama principal.
11. `alu2` deberá incorporar los cambios incluidos en la rama principal.
12. `alu1` cambiará la línea 10 de `cover.css` a:

```css
color: purple;
```

12. `alu1` hará simplemente un commit local en main.
13. `alu2` creará una nueva rama `cool-colors` y cambiará la línea 10 de `cover.css` a:

```css
color: darkgreen;
```

14. `alu2` enviará un PR a `alu1`.
15. `alu1` probará el PR de `alu2` y tendrá que gestionar el posible conflicto al mergear en la rama principal.
16. `alu1` etiquetará esta versión como `0.1.0` y creará una "release" en GitHub apuntando a esta etiqueta.

## Entregable

Informe explicando los pasos seguidos para resolver la tarea. Se entregará el mismo informe por cada pareja y la calificación será la misma para las dos personas.
