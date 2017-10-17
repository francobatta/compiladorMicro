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
"(" {yylval.cadena= strdup(yytext);return PI;}
")" {yylval.cadena= strdup(yytext);return PD;}
"," {return COMA;}
";" {return PUNTOCOMA;}
{DIGITO}+ {yylval.cadena= strdup(yytext);return CONSTANTE;}
{LETRA}{LETRA_DIGITO}{0,31} {yylval.cadena= strdup(yytext);return IDENTIFICADOR;} 
{OPERADOR_ADITIVO} {yylval.cadena= strdup(yytext);return OP_ADITIVO;}
{ASIGNACION} {return ASIGNACION;}
{SEPARADOR} {} /* Ignora */
. {yyerror("Caracter Desconocido, ");}
%%

