/*---------------------------------------------------
 * Compilador PASCAL SIMPLIFICADO PARA MEPA v2023.2
 * 
 * sintatico.y
 *
 * Autor: Fabio Fernandes da Rocha Vicente
 *--------------------------------------------------*/

%{
#include <stdio.h>
#include "lexico.c"

void yyerror(char *msg);
%}

%expect 1 /*if then else: veja a gramática e note que há ambiguidade */
%start programa


%token	SPROGRAM
%token  SBEGIN
%token	SEND
%token  SREAD
%token  SWRITE
%token	SIF
%token	STHEN
%token	SELSE
%token 	SWHILE
%token  SDO

%token	SFOR
%token	STO
%token	SREPEAT
%token	SUNTIL

%token	SMAIS
%token	SMENOS
%token	SVEZES
%token	SDIVI

%token	SMAIOR
%token	SMAIORIGUAL
%token	SMENOR
%token	SMENORIGUAL
%token	SIGUAL
%token	SDIFERENTE

%token	SOR
%token	SAND
%token	SNOT


%token	SATRIB
%token	SABREPAR
%token	SFECHAPAR	
%token	SNUMERO
%token	SID
%token  SPONTOVG
%token  SDOISPONTOS
%token  SPONTO
%token	SVAR
%token	SVIRGULA
%%

programa
	:SPROGRAM	{insereInstrucao("INPP",0);}SID SPONTOVG bloco {insereInstrucao("PARA",0);} SPONTO 
;

bloco
	:nVars corpo
;

nVars
	:/* vazio */
	| SVAR {nVars = 0;} declaracoes_de_vars
;

declaracoes_de_vars
	:declaracoes_de_vars lista_de_identificadores SDOISPONTOS SID SPONTOVG {
		insereInstrucao("AMEM",nVars);
		nVars = 0;
	}
	|lista_de_identificadores SDOISPONTOS SID SPONTOVG {
		insereInstrucao("AMEM",nVars);
		nVars = 0;
		}
;

lista_de_identificadores
	: lista_de_identificadores SVIRGULA SID {
		insereSimbolo(lexema,++ultimo_endereco_alocado,'i','v',escopo_atual);
		nVars++;
	}
	| SID {
		insereSimbolo(lexema,++ultimo_endereco_alocado,'i','v',escopo_atual);
		nVars++;
	}
;

corpo
	: SBEGIN sequencia_comandos SEND
;

sequencia_comandos:
	sequencia_comandos SPONTOVG instrucao
	|instrucao
;



instrucao:
	/* vazio */
	|leitura
	|escrita
	|atribuicao
	|instrucaoIF
	|instrucaoWHILE
	|instrucaoREPEAT
	|instrucaoFOR
	|blocoInstrucoes

;

blocoInstrucoes:
	SBEGIN sequencia_comandos SEND 
;

leitura:
	SREAD SABREPAR lista_de_vars SFECHAPAR
;

lista_de_vars:
	lista_de_vars SVIRGULA SID { 
		insereInstrucao("LEIT",0);
		int endereco = encontraSimbolo(lexema,escopo_atual);
		if(endereco == -1){
				sprintf(mensagem,"Variável [%s] não declarada neste escopo.\n",lexema);
				msgerro(mensagem);
		}else{
			insereInstrucao("ARMZ",endereco);
		}
	}
	|SID { 
		insereInstrucao("LEIT",0);
		int endereco = encontraSimbolo(lexema,escopo_atual);
		if(endereco == -1){
			sprintf(mensagem,"Variável [%s] não declarada neste escopo.\n",lexema);
			msgerro(mensagem);
		}else{
			insereInstrucao("ARMZ",endereco);
		}
	}
;

escrita:
	SWRITE SABREPAR lista_de_expressoes SFECHAPAR
;

lista_de_expressoes:
	lista_de_expressoes SVIRGULA expLogica {insereInstrucao("IMPR",0);}
	| expLogica {insereInstrucao("IMPR",0);}
;

atribuicao:
	SID		{		
			int endereco = encontraSimbolo(lexema,escopo_atual);
			if(endereco == -1){
				sprintf(mensagem,"Variável [%s] não declarada neste escopo.\n",lexema);
				msgerro(mensagem);
			}else{
				push(endereco); //guarda endereco para o ARMNZ endereco
			}
	}
		SATRIB expLogica	{
			endereco = pop();
			insereInstrucao("ARMZ",endereco);

		}
;

instrucaoIF:
	SIF expLogica {
		insereInstrucao("DSVF",-2); //destino desconhecido ainda	
		push(ip); //endereco da instrucao DSVF  
	}
	STHEN instrucao alternativa{
		insereInstrucao("NADA",0);
		int e = pop(); //endereço da instrução DSVF que desviou para cá.
		modificaRotulo(e,ip); //altera lá na DSVF colocando o desvio para cá.
	};
alternativa:
	/*vazio*/
	|SELSE 	{
			int e = pop(); //endereço da instrucao DSVF que desviou para cá;
			insereInstrucao("DSVS",-2); //destino desconhecido ainda;
			push(ip); //endereço desta instrução DSVS
			insereInstrucao("NADA",0);
			modificaRotulo(e,ip);//agora altera lá no DSVF para este endereço aqui.
	}instrucao
;

instrucaoWHILE:
	SWHILE {
		insereInstrucao("NADA",0);
		push(ip); //fará desvio para cá
	} 
	expLogica 	{
		insereInstrucao("DSVF",-2); //destino desconhecido.
		push(ip); //endereço desta instrução
	}
	SDO
	instrucao{
		int e1 = pop();
		int e2 = pop();
		insereInstrucao("DSVS",e2);
		insereInstrucao("NADA",0);
		modificaRotulo(e1,ip); //altera lá no DSVF para este endereço aqui.
	}
;

instrucaoREPEAT:
		SREPEAT {
			insereInstrucao("NADA",0);
			push(ip); //fará desvio para cá
		} 
		instrucao SUNTIL expLogica{
			int e = pop();
			insereInstrucao("DSVF",e);
		}
;

instrucaoFOR:
	SFOR atribuicao{
		insereInstrucao("NADA",0);
		push(ip);
		push(ip-1);
		push(ip-1);
	}
	STO fator{
		int e2 = pop();//endereço da var

		insereInstrucao("CRVL",carregaParametro(e2));

		insereInstrucao("CMMA",0);
		insereInstrucao("DSVF",-2);
		push(ip);

	} SDO blocoInstrucoes{
		int e1 = pop(); //endereço DSVF
		int e2 = pop(); //endereço da variavel contador
		int e3 = pop();//endereço DSVS

		insereInstrucao("CRCT",1);
		insereInstrucao("CRVL",carregaParametro(e2));
		insereInstrucao("SOMA",0);
		insereInstrucao("ARMZ",carregaParametro(e2));
		
		insereInstrucao("DSVS",e3);

		insereInstrucao("NADA",0);
		modificaRotulo(e1,ip); //altera lá no DSVF para este endereço aqui.
		
	}
;

expLogica:	expLogica	SOR	expRelacional	{insereInstrucao("DISJ",0);}
		|expLogica	SAND	expRelacional	{insereInstrucao("CONJ",0);}
		|expRelacional
;

expRelacional:	exp SMAIOR exp  {insereInstrucao("CMMA",0);}
		|exp SMAIORIGUAL exp	{insereInstrucao("CMAG",0);}
		|exp SMENOR exp			{insereInstrucao("CMME",0);}
		|exp SMENORIGUAL exp	{insereInstrucao("CMEG",0);}
		|exp SIGUAL exp			{insereInstrucao("CMIG",0);}
		|exp SDIFERENTE exp		{insereInstrucao("CMIG",0);
								insereInstrucao("INVR",0);
								}
		|exp
;

exp: 	exp SMAIS termo		{insereInstrucao("SOMA",0);}
		|exp SMENOS termo	{insereInstrucao("SUBT",0);}
		|termo
;

termo:	termo SVEZES fator	{insereInstrucao("MULT",0);}
		|termo SDIVI fator	{insereInstrucao("DIVI",0);}
		|SNOT fator			{insereInstrucao("INVR",0);} //verificar tipo de fator.
		|SMENOS fator		{insereInstrucao("CRCT",-1);
							insereInstrucao("MULT",0);
							}
		|fator
;

fator:	SABREPAR expRelacional SFECHAPAR
	|SID	{
			endereco = encontraSimbolo(lexema,escopo_atual);
			if(endereco == -1){
				sprintf(mensagem,"Variável [%s] não declarada neste escopo.\n",lexema);
				msgerro(mensagem);
			}else{
				{insereInstrucao("CRVL",endereco);}
			}
			
	} 	
	|SNUMERO	{
				insereInstrucao("CRCT",atoi(lexema));		

	}

;


%%
void yyerror(char *msg){
	printf("Erro sintático.\n");
	printf("Na LINHA--->%d\n",numero_da_linha);
}


int main(int argc, char **argv){

	FILE *saida;
	yyin = fopen(argv[1],"r");
	saida = fopen(strcat(argv[1],".mep"),"w");
	
	if(yyparse()==0){
		printf("Programa correto.Compilado.\n");
	}else{
		printf("Não foi possível compilar.\n");
	}

	//Grava o programa no arquivo;
	for(int i=0; i<=ip; i++){
		fprintf(saida,"%d\t%s\t%d\n",i,P[i].instrucao,P[i].parametro);
	}
	fclose(saida);
;

}

