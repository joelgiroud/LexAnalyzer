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

extern char *yytext;

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