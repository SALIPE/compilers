%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#define	IP	300
#define	NOVALINHA	400
#define	ESPACOS	500


char lexema[100];
int linha=1;
%}
IP				(2[0-4][0-9]|25[0-5]|[0-9]|[1-9][0-9]|1[0-9]{2})("."(2[0-4][0-9]|25[0-5]|[0-9]|[1-9][0-9]|1[0-9]{2})){3}
%%
{IP}	{strcpy(lexema,yytext);return IP;}
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
			case IP:
				printf("IP:[%s] Na linha:%d\n",yytext,linha);
				break;
		}
		
		token = yylex();
	}
}
