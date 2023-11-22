/*---------------------------------------------------
 * Compilador PASCAL SIMPLIFICADO PARA MEPA v2023.2
 * 
 * lexico.y
 *
 * Autor: Fabio Fernandes da Rocha Vicente
 *--------------------------------------------------*/
 

%{
#include <stdio.h>
#include "utils.c"
#include "sintatico.tab.h"
%}

%option noyywrap

DIGIT	[0-9]
ID		[a-z][a-z0-9]*

%%
program		{return(SPROGRAM);}
begin		{return(SBEGIN);}
end		{return(SEND);}
read		{return(SREAD);}
write		{return(SWRITE);}
if		{return(SIF);}
then		{return(STHEN);}
else		{return(SELSE);}
var		{return(SVAR);}
for		{return(SFOR);}
to		{return(STO);}
repeat	{return(SREPEAT);}
until	{return(SUNTIL);}
while		{return(SWHILE);}
do		{return(SDO);}
"+"		{return(SMAIS);}
"-"		{return(SMENOS);}
"*"		{return(SVEZES);}
"/"		{return(SDIVI);}
">"		{return(SMAIOR);}
">="		{return(SMAIORIGUAL);}
"<"		{return(SMENOR);}
"<="		{return(SMENORIGUAL);}
"<>"		{return(SDIFERENTE);}
"="		{return(SIGUAL);}
":="		{return(SATRIB);}
"("		{return(SABREPAR);}
")"		{return(SFECHAPAR);}
";"		{return(SPONTOVG);}
"."		{return(SPONTO);}
":"		{return(SDOISPONTOS);}	
","		{return(SVIRGULA);}
OR		{return(SOR);}
AND		{return(SAND);}
NOT		{return(SNOT);}

{DIGIT}+	{
			strcpy(lexema,yytext);
			return(SNUMERO);
		}
{ID}		{
			strcpy(lexema,yytext);
			return(SID);
		}
[ \t]		/* FAZ NADA */
[\n]		{numero_da_linha++;}
<<EOF>>		{return 0;}
.		{ printf("\nErro.\n");
		  printf("Símbolo desconhecido:[%s]\n",yytext);
		  printf("LINHA--->%d\n",numero_da_linha);
		  exit(1);
		}
%%
