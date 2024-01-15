#include "lex.yy.c"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
typedef enum {false, true} bool;
char tipoCond[6];
char tipoOpe_log[2];
char tipoOperador[2];
char tipoDelm;
char valorCaracter;
float valorNum;
bool valorBool;
char valorCadena[254];
extern char* manejaid(char arr[]);
extern char *ap_id[32];
extern int numLinea = 0;

struct Nodo{
	char *nombreId;
	int tipo;
	struct Nodo *sig;
};

struct Nodo *Tabla[27];
struct Nodo *ap_id = NULL;
extern char *yytext;

void InicializaTabla(struct Nodo *tablaSimbolos[32]); 
int Llave(char *Id); 
struct Nodo *InsertaId(char *id, int, tipo); 
void EliminaId(char *id); 
void LiberaTabla(struct Nodo *tablaSimbolos[32]); 

main()
{
	char Nombre[100];
	printf("Proporcione el archivo a analizar\n");
	scanf("%s", &Nombre);
	yyin = fopen(Nombre, "r");
	if (yyin == NULL) {
		printf("\nError: El archivo no se pudo abrir \n");
		exit;
	}
	while (!feof(yyin)){
		yylex();
	}
	
	printf("\Éxito en el análisis\n");
}

//Lleva todas las entradas de la tabla a NULL
void InicializaTabla(struct Nodo *tablaSimbolos[32])
{
	int i=0;
	for(i=0; i<32; i++)
		tablaSimbolos[i] = NULL;
}

// Dado un id, dice en qué localidad de la tabla le toca
int Llave(char *nomId)
{
	int i=0, llave = 0;
	for(i=0; i<srtlen(nomId); i++){
		llave = llave + nomId[i];
        }
	llave = llave%32;
	return (llave);
}

//Inserta un nuevo nodo
struct Nodo *Inserta(struct Nodo *tablaSimbolos[32], char *nombreId, int tipo)
{
	int i;
	i = Llave(nombreId);
	struct Nodo *aux = tablaSimbolos[i];
	
	if(aux == NULL){
		tablaSimbolos[i] = (struct Nodo *) malloc(sizeof(struct Nodo));
		tablaSimbolos[i].nombreId = malloc(Strlen(nombreId));
		strcpy(tablaSimbolos[i].nombreId, nombreId);
		tablaSimbolos[i].tipo = tipo;
		tablaSimbolos[i].sig = NULL;
	} else{
		while(aux->sig != NULL) {
			aux = aux->sig;
		}
		aux -> sig = (struct Nodo *) malloc(sizeof(struct Nodo));
		aux -> sig -> nombreId = malloc(Strlen(nombreId));
		strcpy(aux -> sig ->nombreId, nombreId);
		aux -> sig -> tipo = tipo;
		aux -> sig -> sig = NULL;
	}
}

//Elimina un identificador dado
void EliminaId(char *id, struct Nodo *tablaSimbolos[32])
{
	int posicion = Lave(id);
	tablaSimbolos[posicion] = NULL;
	free(tablaSimbolos[posicion]);
}

//Libera los espacios de memoria que ocupan los nodos en la tabla al terminar la compilación
void LiberaTabla(struct Nodo *tablaSimbolos[32])
{
	int i;
	struct Nodo *aux1;
	struct Nodo *aux2;
	for(i=0; i<30; i++){
		aux1 = tablaSimbolos[i];
		aux2 = aux1 -> sig;
		if(aux1->sig == NULL){
			aux1 == NULL;
			free(aux1);
		}
                else{
                    while(aux2 != NULL){
			aux2 = aux1->sig;
			aux1 = NULL;
			free(aux1);
			aux1 = aux2;
                    }
		}
	}
}