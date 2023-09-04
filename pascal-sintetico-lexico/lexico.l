%{
#include <stdio.h>
#include "sintatico.tab.h"
int numero_da_linha=1;
%}

%x COMMENT1 COMMENT2
DIGIT			[0-9]
ID				[a-z][a-z0-9]*
HEX				[0-9A-F]
HEX_DIGIT       ${HEX}{HEX}*

%%
"{"                  BEGIN(COMMENT1);
<COMMENT1>[^}\n]+
<COMMENT1>\n            ++line_number;
<COMMENT1><<EOF>>    yyerror("EOF in comment");
<COMMENT1>"}"        BEGIN(INITIAL);

"(*"                 BEGIN(COMMENT2);
<COMMENT2>[^)*\n]+
<COMMENT2>\n            ++line_number;
<COMMENT2><<EOF>>    yyerror("EOF in comment");
<COMMENT2>"*)"       BEGIN(INITIAL);
<COMMENT2>[*)]

program		{return(SPROGRAM);}
procedure	{return(SPROCEDURE);}
packed		{return(SPACKED);}
record		{return(SRECORD);}
repeat		{return(SREPEAT);}
begin		{return(SBEGIN);}
end			{return(SEND);}
read		{return(SREAD);}
write		{return(SWRITE);}
if			{return(SIF);}
in			{return(SIN);}
then		{return(STHEN);}
else		{return(SELSE);}
case		{return(SCASE);}
var			{return(SVAR);}
const		{return(SCONST);}
label		{return(SLABEL);}
while		{return(SWHILE);}
do			{return(SDO);}
downto		{return(SDOWNTO);}
array		{return(SARRAY);}
file		{return(SFILE);}
for			{return(SFOR);}
function	{return(SFUNCTION);}
goto		{return(SGOTO);}
to			{return(STO);}
type		{return(STYPE);}
until		{return(SUNTIL);}
with		{return(SWITH);}
"+"			{return(SMAIS);}
"-"			{return(SMENOS);}
"*"			{return(SVEZES);}
"/"			{return(SDIVI);}

">"			{return(SMAIOR);}
">="		{return(SMAIORIGUAL);}
"<"			{return(SMENOR);}
"<="		{return(SMENORIGUAL);}
"<>"		{return(SDIFERENTE);}
"="			{return(SIGUAL);}

":="		{return(SATRIB);}
"("			{return(SABREPAR);}
")"			{return(SFECHAPAR);}
";"			{return(SPONTOVG);}
"."			{return(SPONTO);}
".."			{return(SSUPLOPONTO);}
":"			{return(SDOISPONTOS);}	
","			{return(SVIRGULA);}

OR			{return(SOR);}
AND			{return(SAND);}
NOT			{return(SNOT);}
XOR			{return(SXOR);}
DIV			{return(SDIV);}
MOD			{return(SMOD);}
NIL			{return(SNIL);}
SET			{return(SSET);}

{HEX_INTEGER}	{return(SHEX);}
{DIGIT}+	{return(SNUMERO);}
{ID}		{return(SID);}
[ \t]		/* FAZ NADA */
[\n]		{numero_da_linha++;}
<<EOF>>		{return 0;}
.		{ printf("\nErro.\n");
		  printf("Símbolo desconhecido:[%s]\n",yytext);
		  printf("LINHA--->%d\n",numero_da_linha);
		  exit(1);
		}
%%
		

