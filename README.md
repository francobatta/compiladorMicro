# Compilador de lenguaje Micro con Síntesis
### Compilador de lenguaje Micro para la clase de SSL 2017

[Especificación de reglas de Micro](http://docdro.id/DMtvACu)

Usar [Bison](http://gnuwin32.sourceforge.net/packages/bison.htm) y [Flex](http://gnuwin32.sourceforge.net/packages/flex.htm) para compilar

Explicación completa sobre el trabajo [acá](https://github.com/francobatta/compiladorMicro/blob/sintesis/documentacion.pdf)
## Compilar en este orden desde línea de comando para crear el archivo .exe:
1. `bison -d sintactico.y`
1. `flex lexico.l`
1. `gcc lex.yy.c sintactico.tab.c -o compilador.exe`
