/*
 * lexico01.cpp
 * Exemplo de analisador léxico simples.
 * Não identifica o lexema;
 * 
 * Modifique para reconhecer identificadores com caractere "_" (underline)
 *
 */

#include <stdio.h>

#define TRUE  1
#define FALSE 0

#define EOFF   	10
#define	LETRA  	1
#define DIGITO 	2
#define IGNORAR 0

//TOKENS ou SÍMBOLOS TERMINAIS
#define IDENTIFICADOR 	100
#define NUMERO_INTEIRO 	101





//Variaveis globais
int ClasseCaracter;
char c; 
char lexema[300];
int i=0;

//int inicio = TRUE;

/*
 * obtemCaracter()
 * Obtem o proximo caracter da entrada e o classifica (letra ou dígito)
 */
void obtemCaracter(){
	c = getchar();
	if ( ( c >= 'a' && c <= 'z' ) || ( c >= 'A' && c <= 'Z'))
		ClasseCaracter = LETRA;
	else if ( c >= '0' && c <= '9')
		ClasseCaracter = DIGITO;
	else if (c == '*') 
		ClasseCaracter = EOFF;
	else
		ClasseCaracter = IGNORAR;
}

void insereCaracter(){
	lexema[i]=c;
	i++;
}

/*
 * lexico
 */
int lexico(){
//	if(inicio == TRUE){
		obtemCaracter();
//		inicio = FALSE;
//	}
	switch (ClasseCaracter){
		case LETRA:
			while(ClasseCaracter == LETRA || ClasseCaracter == DIGITO){
				insereCaracter();
				obtemCaracter();
			}
			lexema[i]='\0';
			i=0;
			
			return IDENTIFICADOR;
			break;

		case DIGITO:
			while(ClasseCaracter == DIGITO){
				insereCaracter();
				obtemCaracter();
			}
			lexema[i]='\0';
			i=0;
			
			return NUMERO_INTEIRO;
			break;
		case EOF:
			return EOFF;

		default:
			return IGNORAR;
	}
}

int main(){
	int token = lexico();
	while(token != EOF){
		if(token == IDENTIFICADOR){
			printf("ID\n");
			printf("Lexema:%s\n",lexema);
		}else if(token == NUMERO_INTEIRO){
			printf("Número\n");
			printf("Lexema:%s\n",lexema);
		}
	token = lexico();
	};
}
