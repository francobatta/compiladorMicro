# Compilador de lenguaje Micro
Compilador de lenguaje Micro para la clase de SSL 2017
## Compilar en este orden para crear el archivo .exe:
1. `bison -d sintactico.y`
1. `flex lexico.l`
1. `cc lex.yy.c sintactico.tab.c -o compilador -lfl -lm`
## Si se encuentra un error:
* Abrir un issue si el error es complicado
* Si sigue andando el ejecutable una vez cambiados los archivos, committear cambios 
