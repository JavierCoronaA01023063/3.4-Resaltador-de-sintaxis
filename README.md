# 3.4-Resaltador-de-sintaxis

## Reporte
Empezamos nombrando nuestro algoritmo principal, llamado main, que recibe como parámetro un directorio en donde se encuentra el archivo del lenguaje a traducir, en este caso JSON, después entra en acción el algoritmo convert-html, que hereda el mismo parámetro que “main”, lo que hará será ir leyendo el archivo “regexp_test.json” y repasará cada expresión regular hasta encontrar una coincidencia y nombrarlo con dicho “token” además de ponerlo en un sintaxis de html agregando el tag \<span\>, al terminar el resultado se incorporará dentro del archivo preestablecido “regexp_site.html” y todo se guarda dentro de una variable. 

Para finalizar se da a hincapié el algoritmo get-html-output que hereda el mismo parámetro que “main” para poder cambiar de terminación al archivo, en este caso fue de .json a .html, y así poder escribir todo el contenido de la variable anterior dentro del archivo.



Previamente realizamos una breve investigación sobre nuestro algoritmo para saber que tan eficiente es en medida del tiempo de ejecución, analizamos cuántas iteraciones  realiza para poder coincidir cada valor con su respectivo “token” y descubrimos que son 105 en total dentro de un tiempo de 1.54760742188 microsegundos, pero queríamos asegurarnos si tenía una complejidad lineal por lo tanto realizamos el mismo estudio con sólo ⅓ del archivo y nos dio como resultado 35 iteraciones, afirmando así nuestra hipótesis de que la complejidad de nuestro algoritmo es de O(n).
