/*---------------------------------------------------
 * Compilador PASCAL SIMPLIFICADO PARA MEPA v2023.2
 *
 * utils.c
 *
 * Autor: Fabio Fernandes da Rocha Vicente
 *--------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// CONSTANTES E VARIÁVEIS GLOBAIS
//==============================
#define TAMTABELA 10000
int numero_da_linha = 1;
int ultimo_endereco_alocado = -1;
int escopo_atual = 0;
char lexema[100];
int rotulo = 0;		// auxiliar: contador de rótulos (while, do, etc.)
int nVars;			// auxiliar para contar variáveis na declaração
int endereco;		// auxiliar: endereço de memória
char mensagem[300]; // auxiliar: mensagens de erro

#define MAX 100000

//================================
// VETOR DAS INSTRUÇÕES DA MÁQUINA
typedef struct instruction
{
	char instrucao[10];
	int parametro;
} Instrucoes;
Instrucoes P[MAX];
int ip = -1; // apontador de instruções

//===================================
// PILHA SEMÂNTICA
//---Variáveis da PILHA
typedef struct node
{
	int numero;
	struct node *anterior; /* ponteiro para o no anterior */
} NODE;

NODE *topo = NULL;

//-- Variáveis da TABELA DE SÍMBOLOS
int tamanho = -1; // Tamanho atual da tabela de simbolos

typedef struct
{
	char lexema[100];
	int endereco; // endereco de memoria
	char tipo;	  // tipo do dado, quando variavel ou funcao
	int tamanho;  // tamanho do tipo
	char classe;  // o que é: variavel, funcao, constante, etc.
	int escopo;	  // local, global
} LINHA;

LINHA TABELA[TAMTABELA];

//============ FUNCOES DA PILHA ==============
void push(int n)
{
	NODE *novo = (NODE *)malloc(sizeof(NODE));
	if (novo == NULL)
		printf("Erro! Overflow na PILHA.\n\n");
	novo->numero = n;

	if (topo == NULL)
	{
		topo = novo;
	}
	else
	{
		novo->anterior = topo;
		topo = novo;
	}
}

int pop()
{
	if (topo != NULL)
	{
		NODE *aux = topo;
		int x = topo->numero;
		topo = topo->anterior;
		free(aux);
		return x;
	}
	else
		return -1; // pilha vazia
}

// FUNÇÕES DA PILHA DE INSTRUÇÕES
void insereInstrucao(char *instrucao, int parametro)
{
	ip++;
	strcpy(P[ip].instrucao, instrucao);
	P[ip].parametro = parametro;
}

void modificaRotulo(int e, int destino)
{
	// endereco da instrucao
	// endereco destino do desvio
	P[e].parametro = destino;
}

int carregaParametro(int e)
{
	return P[e].parametro;
}
//===================== Funções da tabela de símbolos ==============

// Insere um símbolo na tabela

void insereSimbolo(char *lexema, int endereco, char tipo, char classe, int escopo)
{

	for (int i = 0; i <= tamanho; i++)
	{
		if (!strcmp(lexema, TABELA[i].lexema) && escopo == TABELA[i].escopo)
		{
			printf("Erro na linha:%d\n", numero_da_linha);
			printf("Identificador [%s] já declarado.\n", lexema);
			exit(1);
		}
	}
	// se nao achou, pode inserir
	int i = ++tamanho;
	strcpy(TABELA[i].lexema, lexema);
	TABELA[i].endereco = endereco;
	TABELA[i].tipo = tipo;
	TABELA[i].classe = classe;
	TABELA[i].escopo = escopo;
}

int encontraSimbolo(char *lexema, int escopo)
{

	for (int i = 0; i <= tamanho; i++)
	{
		if (!strcmp(lexema, TABELA[i].lexema) && TABELA[i].escopo != -1 && TABELA[i].escopo == escopo)
		{
			return i;
		}
	}
	// else
	return -1;
}

void msgerro(char *frase)
{
	printf("Erro na linha: %d\n", numero_da_linha);
	printf("%s\n", frase);
	exit(1);
}
