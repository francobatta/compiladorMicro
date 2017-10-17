%{
/* Analizador Sintactico */
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
extern int yylex(void);
extern char *yytext;
extern FILE *yyin;
void yyerror(char *s);
typedef struct Nodo{
    char cadena[33];
    struct Nodo* siguiente;
} Nodo;
typedef struct Lista{
    Nodo* cabeza;
} Lista;
Lista* inicializacion();
Nodo* crearNodo(char *a);
void insertarIdentificador(Lista *lista,char *a);
int estaEnLista(Lista *lista,char *a);
Lista *lista;
%}
%union {
  char * cadena;
}
%error-verbose
%start Programa
%token INICIO
%token FIN
%token <cadena>IDENTIFICADOR
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
Sentencia: IDENTIFICADOR ASIGNACION Expresion PUNTOCOMA {if(estaEnLista(lista,$1)==0){printf("Identificador %s repetido",$1);return 1;}else{insertarIdentificador(lista,$1);}}
	|LEER PI ListaIdentificadores PD PUNTOCOMA 
	|ESCRIBIR PI ListaExpresiones PD PUNTOCOMA
ListaIdentificadores: IDENTIFICADOR {if(estaEnLista(lista,$1)==1){printf("Identificador %s no declarado ",$1);return 1;}}
	| ListaIdentificadores COMA IDENTIFICADOR {if(estaEnLista(lista,$3)==1){printf("Identificador %s no declarado ",$3);return 1;}}
ListaExpresiones: Expresion
	|ListaExpresiones COMA Expresion
Expresion: Primaria
	|Expresion OP_ADITIVO Expresion
Primaria: IDENTIFICADOR {if(estaEnLista(lista,$1)==1){printf("Identificador %s no declarado ",$1);return 1;}}
	| CONSTANTE
	| PI Expresion PD

%%
void yyerror(char *s)
{
printf("Error %s",s);
}
Lista* inicializacion(){
	Lista *lista=(Lista *)malloc(sizeof(Lista));
	lista->cabeza = NULL;
	return lista;
}
Nodo* crearNodo(char *a){
    Nodo* nodo = (Nodo *)malloc(sizeof(Nodo));
    strncpy(nodo->cadena,a,sizeof(nodo->cadena));
    nodo->siguiente=NULL;
    return nodo;
}
void insertarIdentificador(Lista *lista,char *a){
    Nodo* nodo=crearNodo(a);
if(lista->cabeza== NULL){
    lista->cabeza=nodo;
}
else{
     Nodo* aux=lista->cabeza;
     while(aux->siguiente){
            aux = aux->siguiente;
     }
     aux->siguiente=nodo;
}
}
int estaEnLista(Lista *lista,char *a){
	Nodo *aux=lista->cabeza;
	if(aux==NULL){
		return 1;
	}
	else{
		while(aux!=NULL){
			if(strcmp(aux->cadena,a)==0)
			return 0;
			else
			aux=aux->siguiente;
		}
		return 1;
	}
}
int main(int argc,char **argv)
{
lista=inicializacion();
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

