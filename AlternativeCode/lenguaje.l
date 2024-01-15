%{
#define COD_condicional 1
#define COD_delimitador_cierra 2
#define COD_delimitador_abre 3
#define COD_delimitador_comun 4
#define COD_operador 5
#define COD_operador_log 6
#define COD_operador_funcion 7
#define COD_ABRE 8
#define COD_NUM 9
#define COD_CARACTER 10
#define COD_CADENA 11
#define COD_BOOL 12
#define COD_APUNTADOR 13
#define COD_ID 14
#define COD_PROGRAMA 15
#define COD_MIENTRAS 16
#define COD_HACER 17
#define COD_rompe 18
#define COD_escoge 19
#define COD_factorial 20
#define COD_formato 21
#define COD_modulo 22
#define COD_tipoDato 23;
typedef enum {false, true} bool;
char* Maneja_id(char arr[]){
    return &arr[0];
}
extern char valorCaracter;
extern char valorCadena[254];
extern int valorBool;
extern int valorNum;
extern char tipoDelm[1];
extern char tipoOpe_log[2];
extern char tipoOprador[2];
extern char tipoCond[6];
extern char tipoDato[8];
extern int ap_id;
int numLinea = 0;
%}
/*definiciones reg
OMITI LAS COMILLAS COMO DELIMITADOR
Y OMITÍ ALGUNOS CARACTERES ESPECIALES
PORQUE ME FUE IMPOSIBLE RESOLVER LA SINTAXIS*/
caracter_especial "!"|"#"|"$"|"%"|"&"|"/"|"("|")"|"="|"?"|"¡"|"¨"|"*"|"["|"]"|"{"|"}"|"^"|"@"|"^"|"-"|"_"|";"|","|"."|":"|" "
numero [0-9]
letra [a-zA-Z]
comentario_simple "//"
abre_comentario "/*"
cierra_comentario "*/"
delimitador_comun "."|","|"'"|"&"|";"
delimitador_abre "("|"["|"{"
delimitador_cierra ")"|"]"|"}"
operador "+"|"-"|"*"|"/"|"="
operador_log ">="|"<="|"<"|">"|"=="|"||"|"&&"|"!="|"!"
operador_funcion "++"|"+="
condicional "if"|"else"|"elseif"
tipoDato "Entero"|"Flotante"|"Caracter"|"Cadena"|"Booleano"
id {letra}({letra}|{numero})*
entero {numero}+
flotante ({numero}+)"."({numero}+)
caracter {letra}|{caracter_especial}
cadena {caracter}*
booleano [0-1]

%%

"!"                     {   printf("\nEncontré !");
                            return(COD_factorial);
                        }

{comentario_simple}     {   printf("\nEncontré comentario");
                            BEGIN(comentario_linea);
                        }

<comentario_linea>[^\n] {;
                        }
<comentario_linea>\n    {   numLinea=numLinea+1;
                              BEGIN(INITIAL);
                        }

{abre_comentario}       {   printf("\nEncontré /*");
                            BEGIN(comentario);
                        }

<comentario>[^*\n]*         {;/* ignora todo lo que no sea * */
                            }
<comentario>"*"+[^*/\n]*    {;/* ignora los '*' que no contengan '/' después */
                            }
<comentario>\n              {numLinea=numLinea+1;
                            }
<comentario>{cierra_comentario}  {BEGIN(INITIAL);
                                 }

{delimitador_comun}     {   printf("\nEncontré delimitador común");
                            tipoDelm=atoi(yytext);
                            return(COD_delimitador_comun);
                        }

{delimitador_abre}      {   printf("\nEncontré delimitador abre");
                            tipoDelm=atoi(yytext);
                            return(COD_delimitador_abre);
                        }

{delimitador_cierra}    {   printf("\nEncontré delimitador cierra");
                            tipoDelm=atoi(yytext);
                            return(COD_delimitador_cierra);
                        }


{operador}              {   printf("\nEncontré operador");
                            tipoOperador=atoi(yytext);
                            return(COD_operador);
                        }

{operador_log}          {   printf("\nEncontré operador lógico");
                            tipoOpe_log=atoi(yytext);
                            return(COD_operador_log);
                        }

{operador_funcion}      {   printf("\nEncontré operador función");
                            tipoOperador=atoi(yytext);
                            return(COD_operador_funcion);
                        }

{condicional}           {
                           printf("\nEncontré condiciconal");
                           tipoCond=atoi(yytext);
                           return(COD_condicional);
                        }

{tipoDato}              {   printf("\nEncontré una declaración de tipoDato");
                            tipoDato=atoi(yytext);
                            return(COD_tipoDato);
                        }

{id}                    {   printf("\nEncontré id");
                            ap_id=Maneja_id(yytext);
                            return(COD_ID);
                        }

{entero}                {   printf("\nEncontré entero");
                            valorNum=atoi(yytext);
                            return(COD_NUM);
                        }

{flotante}              {   printf("\nEncontré float");
                            valorNum=atoi(yytext);
                            return(COD_NUM);
                        }

{caracter}              {   printf("\nEncontré caracter");
                            valorCaracter=atoi(yytext);
                            return(COD_CARACTER);
                        }

{cadena}                {   printf("\nEncontré cadena");
                            valorCadena=atoi(yytext);
                            return(COD_CADENA);
                        }

{booleano}              {   printf("\nEncontré booleano");
                            valorBool=atoi(yytext);
                            return(COD_BOOL);
                        }

"PROGRAMA"              {   printf("\nEncontré programa");
                            return(COD_PROGRAMA);
                        }

"HACER"                 {   printf("\nEncontré HACER");
                            return(COD_HACER);
                        }

"MIENTRAS"              {   printf("\nEncontré mientras");
                            return(COD_MIENTRAS);
                        }

"rompe"                 {   printf("\nEncontré break");
                            return(COD_rompe);
                        }

"ESCOGE"                {   printf("\nEncontré switch");
                            return(COD_escoge);
                        }

"ABRIR"                 {   printf("\nEncontré abrir");
                            return(COD_ABRE);
                        }

"%"                     {   printf("\nEncontré %");
                            BEGIN(porcentaje);
                        }

<porcentaje>%/{letra}   {   printf("\nEncontré formato '%'");
                            return(COD_formato);
                            BEGIN(INITIAL);
                        }
<porcentaje>%/{numero}+ {   printf("\nEncontré módulo '%'");
                            return(COD_modulo);
                            BEGIN(INITIAL);
                        }

\n                      {   numLinea=numLinea+1;
                        }

[\t]                    {;/*  Saltar los espacios y los tabuladores   */
                        }


.                       {   printf("\nSímbolo no reconocido: ERROR.");
                        }

%%

main(){
    yylex();
    printf( "\n# de líneas = %d", numLinea );
}
