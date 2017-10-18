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
void agregarEscrbirArchivo(FILE *f,char *a);
void nuevoAgregarIdentificadorArchivo(FILE *f,char *s);
void finalizarArchivo(FILE *f);
Lista *lista;
FILE *f;
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
%token <cadena>CONSTANTE
%token COMA
%token <cadena>PI
%token <cadena>PD
%token <cadena>OP_ADITIVO
%type <cadena>Expresion
%type <cadena>Primaria
%%
Programa: INICIO ListaDeSentencias FIN {YYACCEPT;}
ListaDeSentencias: Sentencia
		|ListaDeSentencias Sentencia
Sentencia: IDENTIFICADOR ASIGNACION Expresion PUNTOCOMA {if(estaEnLista(lista,$1)==0){yyerrors(1,$1);YYABORT;}
														else{insertarIdentificador(lista,$1);agregarIdentificadorArchivo(f,$1,$3);}}
	|LEER PI ListaIdentificadores PD PUNTOCOMA
	|ESCRIBIR PI ListaExpresiones PD PUNTOCOMA
ListaIdentificadores: IDENTIFICADOR {if(estaEnLista(lista,$1)==1){
										insertarIdentificador(lista,$1);nuevoAgregarIdentificadorArchivo(f,$1);}
									agregarLeerArchivo(f,$1);}
	| ListaIdentificadores COMA IDENTIFICADOR {if(estaEnLista(lista,$3)==1){insertarIdentificador(lista,$3);nuevoAgregarIdentificadorArchivo(f,$3);}agregarLeerArchivo(f,$3);}
ListaExpresiones: Expresion {agregarEscrbirArchivo(f,$1);}
	|ListaExpresiones COMA Expresion {agregarEscrbirArchivo(f,$3);}
Expresion: Primaria
	|Expresion OP_ADITIVO Expresion {$$=strdup(strcat(strcat($1,$2),$3))}
Primaria: IDENTIFICADOR {if(estaEnLista(lista,$1)==1){yyerrors(0,$1);YYABORT;}}
	| CONSTANTE 
	| PI Expresion PD {$$=strdup(strcat(strcat($1,$2),$3))}

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
int ret;
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
 printf("Compilado Correctamente\n Presione una tecla para salir...");finalizarArchivo(f); break;
case 1:
	ret = remove("ylaquinta.c");
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
	f=fopen("ylaquinta.c","w");
	fprintf(f,"#include <stdio.h>\n");
	fclose(f);
	f=fopen("ylaquinta.c","a+");
	fprintf(f,"#include <stdlib.h>\n");
	fprintf(f,"int main(){\n");
	fclose(f);
}
void agregarIdentificadorArchivo(FILE *f,char *s,char *a){
	f=fopen("ylaquinta.c","a+");
	fprintf(f,"int %s = %s;\n",s,a);
	fclose(f);
}
void nuevoAgregarIdentificadorArchivo(FILE *f,char *s){
	f=fopen("ylaquinta.c","a+");
	fprintf(f,"int %s;\n",s);
	fclose(f);
}
void agregarLeerArchivo(FILE *f,char *a){
	f=fopen("ylaquinta.c","a+");
	fprintf(f,"scanf(\"%%d\",&%s);\n",a);
	fclose(f);
}
void agregarEscrbirArchivo(FILE *f,char *a){
	f=fopen("ylaquinta.c","a+");
	fprintf(f,"printf(\"%%d\\n\",%s);\n",a);
	fclose(f);
}
void finalizarArchivo(FILE *f){
	f=fopen("ylaquinta.c","a+");
	fprintf(f,"\nreturn 0;\n}");
	fclose(f);
}
