%option noyywrap

%{
#include <stdio.h>
#include <string.h>
int linha=1;
%}
NUMERO		[0-9]+
NOMEPROPRIO	[A-Z][a-z]+
%%

{NUMERO}	{printf("Achei um número.\n");}
{NOMEPROPRIO}	{printf("Achei um nome próprio (talvez?).\n");}
[ \t]		/* ignora */
\n		{linha++;}
"*"		{exit(0);}
.		/*ignora*/

%%

int main(int argc, char **argv){
	if(argc<2){
		printf("Erro!\n");
		printf("./exemplo02.bin <nome_do_arquivo_entrada>\n");
		exit(1);
	}else{
		yyin = fopen(argv[1],"r");
	}
	yylex();
}
