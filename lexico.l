%option noyywrap /* Avisa que solo leera un archivo */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sintactico.tab.h"
%} /* Finaliza inclusion de librerias*/
LETRA [a-zA-Z]
DIGITO [0-9]
OPERADOR_ADITIVO [+|-]
ASIGNACION :=
LETRA_DIGITO ({LETRA}|{DIGITO})
SEPARADOR ([ \t\n])+ /* Para ignorar espacios en blanco*/
void yyerror(char *);
%% /* Finaliza declaracion de tokens*/
inicio {return INICIO;}
fin {return FIN;}
leer {return LEER;}
escribir {return ESCRIBIR;}
"(" {yylval.cadena= strdup(yytext);return PI;}/* yylval=strdup... sirve para que se pueda realizar el proceso de sintesis*/
")" {yylval.cadena= strdup(yytext);return PD;}/* yylval guarda el contenido de la deteccion para su futuro uso */
"," {return COMA;}
";" {return PUNTOCOMA;}
{DIGITO}+ {yylval.cadena= strdup(yytext);return CONSTANTE;}
{LETRA}{LETRA_DIGITO}{0,31} {yylval.cadena= strdup(yytext);return IDENTIFICADOR;} /* Limite de 32 caracteres para los ID */ 
{OPERADOR_ADITIVO} {yylval.cadena= strdup(yytext);return OP_ADITIVO;}
{ASIGNACION} {return ASIGNACION;}
{SEPARADOR} {} /* Ignora espacio en blanco */
. {yyerror("Caracter Desconocido, ");} /* El punto detecta cualquier input. Debido a la naturaleza secuencial del analizador, se pone a lo ultimo*/
%% /* Finaliza reglas.*/
/* Parte en C implementada en especificacion sintactica */
