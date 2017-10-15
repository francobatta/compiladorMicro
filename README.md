# compiladorMicro
Compilador de lenguaje Micro para la clase de SSL 2017
##Compilar en este orden para crear el archivo *.exe*:
1. `<bison -d sintactico.y>`
1. `<flex lexico.l>`
1. `<cc lex.yy.c sintactico.tab.c -o compilador -lfl -lm>`
