%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#define	NUMERO 100
#define	NOMEPROPRIO 200
#define	ESPACOS	300
#define NOVALINHA 400
#define	CPF 500

int linha=1;
%}
NUMERO		[0-9]+
NOMEPROPRIO	[A-Z][a-z]+
CPF		[0-9]{3}"."[0-9]{3}"."[0-9]{3}"-"[0-9]{2}
%%

{CPF}		{ printf("CPF:[%s]\n",yytext);
		  return CPF;
		 }
{NUMERO}	{ printf("Lexema:[%s]\n",yytext);
		  return NUMERO;
		}

{NOMEPROPRIO}	{ printf("Nome:[%s]\n",yytext);
		  return NOMEPROPRIO;
		}
[ \t]		{return ESPACOS;  }
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
			printf("Linha do nome próprio: %d\n",yytext,linha);
		}
		token = yylex();
	}
}
