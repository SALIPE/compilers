%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#define	NUMERO 100
#define	NOMEPROPRIO 200
#define	ESPACOS	300
#define NOVALINHA 400
#define	CPF 500

char lexema[100];

int linha=1;
%}
NUMERO		[0-9]+
NOMEPROPRIO	[A-Z][a-z]+
CPF		[0-9]{3}"."[0-9]{3}"."[0-9]{3}"-"[0-9]{2}
%%

{CPF}		{strcpy(lexema,yytext);
		return CPF;
		}
{NUMERO}	{return NUMERO;}
{NOMEPROPRIO}	{return NOMEPROPRIO;}
[ \t]		{return ESPACOS;}
\n		{linha++;
		 return NOVALINHA;
		}
<<EOF>>		{return 0;}
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
	
	int token = yylex();
	while(token != 0){
		if(token == NOMEPROPRIO){
			printf("Nome:[%s]:%d\n",yytext,linha);
			token = yylex();
			while(token != CPF){
				token = yylex();
			}
			printf("CPF:%s\n",lexema);
		}
		
		token = yylex();
	}
}
