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
    char cadena[32];
    struct Nodo* siguiente;
} Nodo;
typedef struct Lista{
    Nodo* cabeza;
} Lista;
void mostrarLista(Lista *lista);
Lista* inicializacion();
Nodo* crearNodo(char *a);
void insertarIdentificador(Lista *lista,char *a);
Lista *lista;
%}
%union {
  char * cadena;
  int guiver;
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
Programa: INICIO ListaDeSentencias FIN {printf("Compilado Correctamente\n Presione una tecla para salir...");mostrarLista(lista);return 0;}
ListaDeSentencias: Sentencia
		|ListaDeSentencias Sentencia
Sentencia: IDENTIFICADOR ASIGNACION Expresion PUNTOCOMA {insertarIdentificador(lista,$1)}
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
void mostrarLista(Lista *lista){
      Nodo *aux=lista->cabeza;
while(aux!=NULL){
    printf("%s",aux->cadena);
    aux=aux->siguiente;
}
}
int main(int argc,char **argv)
{
lista=(Lista *)malloc(sizeof(Lista));
lista->cabeza = NULL;
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
