%{
#define COD_delimitador_comun 1
#define COD_delimitador_abre 2
#define COD_delimitador_cierra 3
#define COD_operador 4
#define COD_operador_log 5
#define COD_operador_funcion 6
#define COD_pal_res 7
#define COD_ID 8
#define COD_NUM 9
#define COD_CARACTER 10
#define COD_CADENA 11
#define COD_BOOL 12
#define COD_int 13
#define COD_float 14
#define COD_break 15
#define COD_ABRE 16
typedef enum {false, true} bool;
char* Maneja_id(char arr[]){
    return &arr[0];
}
extern char tipoCond[6];
extern char tipoOpe_log[2];
extern char tipoOperador[2];
extern char tipoDelm;
extern char valorCaracter;
extern float valorNum;
extern bool valorBool;
extern char valorCadena[254];
char *ap_id[32];
int numLinea = 0;
%}
/*definiciones reg
OMITI LAS COMILLAS COMO DELIMITADOR
PORQUE ME FUE IMPOSIBLE RESOLVER LA SINTAXIS*/
numero [0-9]
letra [a-zA-Z]
booleano "true"|"false"
comentario_simple "//"
abre_comentario "/*"
cierra_comentario "*/"
pal_res "if"|"else"|"while"|"do"|"return"
delimitador_comun "."|","|"'"|"&"|";"
delimitador_abre "("|"["|"{"
delimitador_cierra ")"|"]"|"}"
operador "+"|"-"|"*"|"/"|"="
operador_log ">="|"<="|"<"|">"|"=="|"||"|"&&"|"!="|"!"
operador_funcion "++"|"+="
id {letra}({letra}|{numero})*
entero {numero}+
flotante ({numero}+)"."({numero}+)
caracter {letra}|{numero}|{operador}|{delimitador_abre}|{delimitador_cierra}|{delimitador_comun}
cadena {caracter}*

%%

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

{pal_res}               {   printf("\nEncontré pal_res");
                           tipoCond=atoi(yytext);
                           return(COD_pal_res);
                        }


{id}                    {   printf("\nEncontré id %s", yytext);
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

"int"                   {   printf("\nEncontré int");
                            return(COD_int);
                        }

"float"                 {   printf("\nEncontré float");
                            return(COD_float);
                        }


"break"                 {   printf("\nEncontré break");
                            return(COD_break);
                        }

"ABRIR"                 {   printf("\nEncontré abrir");
                            return(COD_ABRE);
                        }

\n                      {   numLinea=numLinea+1;
                        }

\t                      {;/*  Saltar los espacios y los tabuladores   */
                        }


.                       {   printf("\nSímbolo %c reconocido: ERROR.", yytext[0]);
                        }

%%

main(){
    yylex();
    printf( "\n# de líneas = %d", numLinea );
}