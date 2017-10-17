%{
/* Analizador Sintactico */
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
extern int yylex(void);
extern char *yytext;
extern FILE *yyin;
void yyerror(char *s);
%}
%error-verbose
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
Programa: INICIO ListaDeSentencias FIN {printf("Compilado Correctamente\n Presione una tecla para salir...");return 0;}
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
if (argc>3 || argc<1)
{printf("Error, cantidad incorrecta de parametros");
getch();
return 1;}
else if (argc==2)
 {yyin=fopen(argv[1],"rt");
 printf("Archivo %s abierto\n",argv[1]);}
else
 {printf("Por favor ingrese programa a ser compilado\n");
 yyin=stdin;}
yyparse(); getch();
}
