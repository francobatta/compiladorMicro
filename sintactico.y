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
void yyerrors(char *s);
void inicializarArchivo(FILE *f);
int estaEnLista(Lista *lista,char *a);
void agregarIdentificadorArchivo(FILE *f,char *s);
void asignarValorIdentiAarchivo(FILE *f,char *s,char *a);
void agregarLeerArchivo(FILE *f,char *a);
void agregarEscrbirArchivo(FILE *f,char *a);
void finalizarArchivo(FILE *f);
Lista *lista;
FILE *f;
%} // Fin prototipo funciones
%union {
  char * cadena;
} // Declara tipo de dato char como <cadena>
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
%% // Fin declaracion tokens
Programa: INICIO ListaDeSentencias FIN {YYACCEPT;}
ListaDeSentencias: Sentencia
		|ListaDeSentencias Sentencia
Sentencia: IDENTIFICADOR ASIGNACION Expresion PUNTOCOMA {if(estaEnLista(lista,$1)){asignarValorIdentiAarchivo(f,$1,$3);}
														else{insertarIdentificador(lista,$1);agregarIdentificadorArchivo(f,$1);
															asignarValorIdentiAarchivo(f,$1,$3);}}
                            // Rutina de asignacion
	|LEER PI ListaIdentificadores PD PUNTOCOMA
	|ESCRIBIR PI ListaExpresiones PD PUNTOCOMA
ListaIdentificadores: IDENTIFICADOR {if(!estaEnLista(lista,$1)){insertarIdentificador(lista,$1);agregarIdentificadorArchivo(f,$1);}
									agregarLeerArchivo(f,$1);}
                            // Rutina de lectura
	| ListaIdentificadores COMA IDENTIFICADOR {if(!estaEnLista(lista,$3)){insertarIdentificador(lista,$3);agregarIdentificadorArchivo(f,$3);}
												agregarLeerArchivo(f,$3);}
ListaExpresiones: Expresion {agregarEscrbirArchivo(f,$1);}
	|ListaExpresiones COMA Expresion {agregarEscrbirArchivo(f,$3);}
                            // Rutina de escritura
Expresion: Primaria
	|Expresion OP_ADITIVO Expresion {$$=strdup(strcat(strcat($1,$2),$3))}
Primaria: IDENTIFICADOR {if(!estaEnLista(lista,$1)){yyerrors($1);YYABORT;}}
	| CONSTANTE
	| PI Expresion PD {$$=strdup(strcat(strcat($1,$2),$3))}
%%
void yyerror(char *s)
{
printf("Error %s",s);
}
// Inicio funciones lista
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
// Fin funciones lista
// Inicio funciones semanticas
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
		return 0;
	}
	else{
		while(aux!=NULL){
			if(strcmp(aux->cadena,a)==0)
			return 1;
			else
			aux=aux->siguiente;
		}
		return 0;
	}
}
void yyerrors(char *s){
		printf("Identificador %s no declarado ",s);
}
// Fin funciones semanticas
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
              // Rutina Fin
case 1:
	ret = remove("salidaEnC.c"); // Borrar archivo salida ante error
 puts("\nCompilacion abortada"); break;
case 2:
 puts("Memoria insuficiente"); break;
}
getch();
return 0;
}
// Inicio funciones de sintesis
void inicializarArchivo(FILE *f){
	f=fopen("salidaEnC.c","w");
	fprintf(f,"/*Sintesis del programa en micro en C*/\n");
	fprintf(f,"#include <stdio.h>\n");
	fprintf(f,"#include <stdlib.h>\n");
	fprintf(f,"int main(){\n");
	fclose(f);
}
void agregarIdentificadorArchivo(FILE *f,char *s){
	f=fopen("salidaEnC.c","a+");
	fprintf(f,"int %s;\n",s);
	fclose(f);
}
void asignarValorIdentiAarchivo(FILE *f,char *s,char *a){
	f=fopen("salidaEnC.c","a+");
	fprintf(f,"%s = %s;\n",s,a);
	fclose(f);
}
void agregarLeerArchivo(FILE *f,char *a){
	f=fopen("salidaEnC.c","a+");
	fprintf(f,"scanf(\"%%d\",&%s);\n",a);
	fclose(f);
}
void agregarEscrbirArchivo(FILE *f,char *a){
	f=fopen("salidaEnC.c","a+");
	fprintf(f,"printf(\"%%d\\n\",%s);\n",a);
	fclose(f);
}
void finalizarArchivo(FILE *f){
	f=fopen("salidaEnC.c","a+");
	fprintf(f,"\nreturn 0;\n}");
	fclose(f);
}
// Fin funciones de sintesis
