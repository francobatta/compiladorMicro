# Compilador de lenguaje Micro 
## Versión con semántico basado en listas
```
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
```
Compilador de lenguaje Micro para la clase de SSL 2017

[Especificación de reglas de Micro](http://docdro.id/DMtvACu)

Usar [Bison](http://gnuwin32.sourceforge.net/packages/bison.htm) y [Flex](http://gnuwin32.sourceforge.net/packages/flex.htm) para compilar
## Compilar en este orden desde línea de comando para crear el archivo .exe:
1. `bison -d sintactico.y`
1. `flex lexico.l`
1. `gcc lex.yy.c sintactico.tab.c -o compilador.exe`
## Si se encuentra un error:
* Abrir un issue
* Si sigue andando el ejecutable una vez cambiados los archivos, committear cambios 
* Hacer un *Release* si los cambios son significativos (o sea, subir el .exe)
