/*
 * lexico01.cpp
 * Exemplo de analisador léxico simples.
 * Não identifica o lexema;
 *
 * Modifique para reconhecer identificadores com caractere "_" (underline)
 *
 */

#include <stdio.h>

#define TRUE 1
#define FALSE 0

#define VAZIO 0
#define LETRA 1
#define DIGITO 2
#define UNDERLINE 3

#define IDENTIFICADOR 100
#define NUMERO_INTEIRO 101

// Variaveis globais
int ClasseCaracter;
char c;
char lexema[300];
int i = 0;

// int inicio = TRUE;

/*
 * obtemCaracter()
 * Obtem o proximo caracter da entrada e o classifica (letra ou dígito)
 */
void obtemCaracter()
{
	c = getchar();
	if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))
		ClasseCaracter = LETRA;
	else if (c == 95)
		ClasseCaracter = UNDERLINE;
	else if (c >= '0' && c <= '9')
		ClasseCaracter = DIGITO;
	else
		ClasseCaracter = VAZIO;
}

void insereCaracter()
{
	lexema[i] = c;
	i++;
}
/*
 * lexico
 */
int lexico()
{
	//	if(inicio == TRUE){
	obtemCaracter();
	//		inicio = FALSE;
	//	}
	switch (ClasseCaracter)
	{
	case UNDERLINE:
	case LETRA:
		while (ClasseCaracter == LETRA || ClasseCaracter == DIGITO || ClasseCaracter == UNDERLINE)
		{
			insereCaracter();
			obtemCaracter();
		}
		printf("[IDENTIFICADOR]\n");
		lexema[i] = '\0';
		i = 0;
		return IDENTIFICADOR;
		break;

	case DIGITO:
		while (ClasseCaracter == DIGITO)
		{
			insereCaracter();
			obtemCaracter();
		}
		printf("[DIGITO]\n");
		lexema[i] = '\0';
		i = 0;
		return NUMERO_INTEIRO;
		break;

	default:
		return 0;
	}
}

int main()
{
	int token = lexico();
	while (token != 0)
	{
		if (token == IDENTIFICADOR)
		{
			printf("ID\n");
			printf("Lexema:%s\n", lexema);
		}
		else if (token == NUMERO_INTEIRO)
		{
			printf("Número\n");
			printf("Lexema:%s\n", lexema);
		}
		token = lexico();
	}
}
