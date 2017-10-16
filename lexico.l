%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sintactico.tab.h"
%}
LETRA [a-zA-Z]
DIGITO [0-9]
OPERADOR_ADITIVO [+|-]
ASIGNACION :=
LETRA_DIGITO ({LETRA}|{DIGITO})
SEPARADOR ([ \t\n])+
void yyerror(char *);
%%
inicio {return INICIO;}
fin {return FIN;}
leer {return LEER;}
escribir {return ESCRIBIR;}
"(" {return PI;}
")" {return PD;}
"," {return COMA;}
";" {return PUNTOCOMA;}
{DIGITO}+ {return CONSTANTE;}
{LETRA}{LETRA_DIGITO}{0,31} {return IDENTIFICADOR;}
{OPERADOR_ADITIVO} {return OP_ADITIVO;}
{ASIGNACION} {return ASIGNACION;}
{SEPARADOR} {} /* Ignora */
. {yyerror("Caracter Desconocido");}
%%
