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
void yyerrors(int tipo,char *s);
void inicializarArchivo(FILE *f);
int estaEnLista(Lista *lista,char *a);
void agregarIdentificadorArchivo(FILE *f,char *s,char *a);
void agregarLeerArchivo(FILE *f,char *a);
Lista *lista;
FILE *f;
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
%token <cadena>CONSTANTE
%token COMA
%token <cadena>PI
%token <cadena>PD
%token <cadena>OP_ADITIVO
%%
Programa: INICIO ListaDeSentencias FIN {YYACCEPT;}
ListaDeSentencias: Sentencia
		|ListaDeSentencias Sentencia
Sentencia: IDENTIFICADOR ASIGNACION Expresion PUNTOCOMA {if(estaEnLista(lista,$1)==0){yyerrors(1,$1);YYABORT;}
														else{insertarIdentificador(lista,$1);agregarIdentificadorArchivo(f,$1,$<cadena>3);}}
	|LEER PI ListaIdentificadores PD PUNTOCOMA 
	|ESCRIBIR PI ListaExpresiones PD PUNTOCOMA
ListaIdentificadores: IDENTIFICADOR {if(estaEnLista(lista,$1)==1){yyerrors(0,$1);YYABORT;}else{agregarLeerArchivo(f,$1);}}
	| ListaIdentificadores COMA IDENTIFICADOR {if(estaEnLista(lista,$3)==1){yyerrors(0,$3);YYABORT;}else{agregarLeerArchivo(f,$3);}}
ListaExpresiones: Expresion
	|ListaExpresiones COMA Expresion
Expresion: Primaria
	|Expresion OP_ADITIVO Expresion 
Primaria: IDENTIFICADOR {if(estaEnLista(lista,$1)==1){yyerrors(0,$1);YYABORT;}}
	| CONSTANTE
	| PI Expresion PD {strcat($<cadena>$,strcat(strcat($1,$<cadena>2),$3))}

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
inicializarArchivo(f);
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
switch(yyparse()){
case 0:
 printf("Compilado Correctamente\n Presione una tecla para salir..."); break;
case 1:
 puts("\nCompilacion abortada"); break;
case 2:
 puts("Memoria insuficiente"); break;
}
getch();
return 0;
}
void yyerrors(int tipo,char *s){
	switch(tipo){
		case 0:
		printf("Identificador %s no declarado ",s);break;
		case 1:
		printf("Identificador %s repetido",s);break;
	}
}
void inicializarArchivo(FILE *f){
	f=fopen("mica.txt","w");
	fprintf(f,"#include <stdio.h>\n");
	fclose(f);
	f=fopen("mica.txt","a+");
	fprintf(f,"#include <stdlib.h>\n");
	fprintf(f,"int main(){");
	fclose(f);
}
void agregarIdentificadorArchivo(FILE *f,char *s,char *a){
	f=fopen("mica.txt","a+");
	fprintf(f,"int %s = %s;\n",s,a);
	fclose(f);
}
void agregarLeerArchivo(FILE *f,char *a){
	f=fopen("mica.txt","a+");
	fprintf(f,"scanf(%%s,%s);\n",a);
	fclose(f);
}
