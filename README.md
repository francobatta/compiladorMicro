# Compilador de lenguaje Micro
Compilador de lenguaje Micro para la clase de SSL 2017

[Especificación de reglas de Micro](http://docdro.id/DMtvACu)

Usar [Bison](http://gnuwin32.sourceforge.net/packages/bison.htm) y [Flex](http://gnuwin32.sourceforge.net/packages/flex.htm) para compilar
## Compilar en este orden desde línea de comando para crear el archivo .exe:
1. `bison -d sintactico.y`
1. `flex lexico.l`
1. `cc lex.yy.c sintactico.tab.c -o compilador -lfl -lm`
## Si se encuentra un error:
* Abrir un issue
* Si sigue andando el ejecutable una vez cambiados los archivos, committear cambios 
* Hacer un *Release* si los cambios son significativos (o sea, subir el .exe)
