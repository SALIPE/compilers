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

#define VAZIO  0
#define	LETRA  1
#define DIGITO 2

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

}
void acrescentaCaracter(){
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
				obtemCaracter();
			}
			printf("[IDENTIFICADOR]\n");
			return IDENTIFICADOR;
			break;

		case DIGITO:
			while(ClasseCaracter == DIGITO){
				obtemCaracter();
			}
			printf("[DIGITO]\n");
			return NUMERO_INTEIRO;
			break;

		default:
			return 0;
	}
}

int main(){
	while(lexico() != 0);
}
