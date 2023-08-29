%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#define	IDENTIFICADOR 100
#define	OPERADOR 200
#define	RESERVADO	300
#define	NOVALINHA	400
#define	ESPACOS	500
#define	NUMERO	600


char lexema[100];
int linha=1;
%}
NUMERO				[0-9]?
RESERVADO			while|if|else|do|include|define|struct|for|int|char|float|double|string|short
IDENTIFICADOR		[a-z]+[a-zA-Z_]*[0-9]*			
OPERADOR			"*"|"/"|"+"|"-"|"%"|"||"|"&&"|"=="|"!="|"="
%%
{NUMERO}	{strcpy(lexema,yytext);return NUMERO;}
{RESERVADO}	{strcpy(lexema,yytext);return RESERVADO;}
{IDENTIFICADOR}	{strcpy(lexema,yytext);return IDENTIFICADOR;}
{OPERADOR}	{strcpy(lexema,yytext);return OPERADOR;}
[ \t]		{return ESPACOS;}
\n		{linha++;
		 return NOVALINHA;
		}
"."		{return 0;}

%%

int main(int argc, char **argv){
	if(argc > 1){
		yyin = fopen(argv[1],"r");
	}

	int token = yylex();
	while(token != 0){
		switch(token){
			case IDENTIFICADOR:
				printf("IDENTIFICADOR:[%s] Na linha:%d\n",yytext,linha);
				break;
			case NUMERO:
				printf("NUMERO:[%s] Na linha:%d\n",yytext,linha);
				break;
			case OPERADOR:
				printf("OPERADOR:[%s] Na linha:%d\n",yytext,linha);
				break;
			case RESERVADO:
				printf("PALAVRA RESERVADA:[%s] Na linha:%d\n",yytext,linha);
				break;
		}
		
		token = yylex();
	}
}
