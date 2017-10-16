%{
/* Analizador Sintactico */
#include <stdio.h>
#include <stdlib.h>
extern int yylex(void);
extern char *yytext;
extern FILE *yyin;
void yyerror(char *s);
%}
%start Programa
%token INICIO
%token FIN
%token IDENTIFICADOR
%token LEER
%token ESCRIBIR
%token ASIGNACION
%token PUNTOCOMA
%token CONSTANTE
%token COMA
%token PI
%token PD
%token OP_ADITIVO
%%
Programa: INICIO ListaDeSentencias FIN {printf("Compilado Correctamente\n");}
ListaDeSentencias: Sentencia
		|ListaDeSentencias Sentencia
Sentencia: IDENTIFICADOR ASIGNACION Expresion PUNTOCOMA
	|LEER PI ListaIdentificadores PD PUNTOCOMA
	|ESCRIBIR PI ListaExpresiones PD PUNTOCOMA
ListaIdentificadores: IDENTIFICADOR
	| ListaIdentificadores COMA IDENTIFICADOR
ListaExpresiones: Expresion
	|ListaExpresiones COMA Expresion
Expresion: Primaria
	|Expresion OP_ADITIVO Expresion
Primaria: IDENTIFICADOR
	| CONSTANTE
	| PI Expresion PD
 
%%
void yyerror(char *s)
{
printf("Error %s",s);
}
int main(int argc,char **argv)
{
if (argc>1 || argc<0)
{printf("Error, cantidad incorrecta de parametros");getchar();return 1;}
else if (argc==1)
 yyin=fopen(argv[1],"rt");
else
 yyin=stdin;
yyparse();
if (argc==0)
getchar();
getchar();
return 0;
}
