/*---------------------------------------------------
 * Compilador PASCAL SIMPLIFICADO PARA MEPA v2023.2
 * 
 * mepasimples.c
 *
 * Autor: Fabio Fernandes da Rocha Vicente
 *--------------------------------------------------*/
 
 
 #include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define MAX 1000

typedef struct instruction{
	char instrucao[5];
	int  parametro;
}Instrucoes;

/* --------------------------------------
   ARQUITETURA DA MÁQUINA VIRTUAL
   --------------------------------------
*/
int i=0;    /* registrador instruction pointer */	
int s=-1;   /* registrador stack pointer */	
int        M[MAX]; /* dados = memória */
Instrucoes P[MAX]; /* programa */

int tamanho=0; /* tamanho do programa carregado (em posições na memória P)*/

/* ------------------------------------------
  Função que carrega o arquivo executável
  para a memória P (Programa) da máquina
  virtual.
   ------------------------------------------
*/
void loader(char *arquivo){
	FILE *fp = fopen(arquivo,"r");
	char inst[5];
	int  par;	
	int i=-1;//índice do vetor P
	
	int linha; //O loader IGNORA a linha, que serve apenas para a leitura humana do arquivo .mep
	fscanf(fp,"%d\t%s\t%d\n",&linha,inst,&par);
	while(strcmp(inst,"PARA")){
		i++;

		strcpy(P[i].instrucao,inst);
		P[i].parametro = par;
		tamanho++;	

		fscanf(fp,"%d\t%s\t%d\n",&linha,inst,&par);
	}
		i++;
		strcpy(P[i].instrucao,"PARA");
		P[i].parametro = 0;
		tamanho++;
		
		fclose(fp);

}	


/* -----------------------
   Mostra o status de P 
   -----------------------
*/
void statusP(){
	for(int y=1; y<tamanho; y++){
		printf("%d:\t[%s]\t[%d]\t",y,P[y].instrucao,P[y].parametro);
		if(i == y) printf("<--i\n");
		else printf("\n");
	}
	
}

/* -----------------------
   Mostra o status de M
   -----------------------
*/
void statusM(){
	for(int y=s; y>=1; y--){
		printf("%d:\t[%d]\t<--s\n",y,M[y]);

	}
}


int main(int argc, char **argv){
	if(argc < 2){
		printf("USO:\n");
		printf("\t./mepa <arquivo.mep>\n\n");
		exit(1);	
	}
	
	int n; /*auxiliar*/
	loader(argv[1]);
	//statusP();
	//statusM();

	i=1;
	while(1){
		n = P[i].parametro;	
		if (!strcmp(P[i].instrucao,"CRVL")){
			s++;
			M[s] = M[n];	
			i++;	
		}else 
		if(!strcmp(P[i].instrucao,"CRCT")){
			s++;
			M[s] = n;
			i++;
		}else 
		if(!strcmp(P[i].instrucao,"SOMA")){
			M[s-1] = M[s-1]+M[s];
			s--;
			i++;
		}else 
		if(!strcmp(P[i].instrucao,"SUBT")){
			M[s-1] = M[s-1] - M[s];
			s--;
			i++;	
		}else 
		if(!strcmp(P[i].instrucao,"MULT")){
			M[s-1] = M[s-1]*M[s];
			s--;
			i++;	
		
		}else 
		if(!strcmp(P[i].instrucao,"DIVI")){
			M[s-1] = M[s-1]/M[s];
			s--;
			i++;	
		}else 
		if(!strcmp(P[i].instrucao,"IMPR")){
			printf("*: %d\n",M[s]);
			s--;
			i++;
		}else 
		if(!strcmp(P[i].instrucao,"AMEM")){
			s = s + n ;
			i++;
		}else
		if(!strcmp(P[i].instrucao,"ARMZ")){
			M[n] = M[s];
			s--;
			i++;
		}else
		if(!strcmp(P[i].instrucao,"DSVS")){
			i = n;
		}else
		if(!strcmp(P[i].instrucao,"DSVF")){
			if(M[s] == 0){
				i = n;
				s--;
			}else{
				i++;
				s--;
			}
		}else
		if(!strcmp(P[i].instrucao,"CMME")){
			if(M[s-1] < M[s]){
				s--;
				M[s]=1;
				i++;
			}else{
				s--;
				M[s]=0;
				i++;
			}
		}else
		if(!strcmp(P[i].instrucao,"CMEG")){
			if(M[s-1] <= M[s]){
				s--;
				M[s]=1;
				i++;
			}else{
				s--;
				M[s]=0;
				i++;
			}
		}else
		if(!strcmp(P[i].instrucao,"CMMA")){
			if(M[s-1] > M[s]){
				s--;
				M[s]=1;
				i++;
			}else{
				s--;
				M[s]=0;
				i++;
			}
		}else
		if(!strcmp(P[i].instrucao,"CMAG")){
			if(M[s-1] >= M[s]){
				s--;
				M[s]=1;
				i++;
			}else{
				s--;
				M[s]=0;
				i++;
			}
		}else
		if(!strcmp(P[i].instrucao,"CMIG")){
			if(M[s-1] == M[s]){
				s--;
				M[s]=1;
				i++;
			}else{
				s--;
				M[s]=0;
				i++;
			}
		}else
		if(!strcmp(P[i].instrucao,"INVR")){
			if(M[s] == 0) M[s] = 1;
			else M[s] = 0;
			//s--;
			i++;
		}else
		if(!strcmp(P[i].instrucao,"CONJ")){
			if(M[s-1] && M[s]){
				s--;
				M[s]=1;
				i++;
			}else{
				s--;
				M[s]=0;
				i++;
			}
		}else
		if(!strcmp(P[i].instrucao,"DISJ")){
			if(M[s-1] || M[s]){
				s--;
				M[s]=1;
				i++;
			}else{
				s--;
				M[s]=0;
				i++;
			}
		}else
		if(!strcmp(P[i].instrucao,"INPP")){
			s = -1;
			i++;
		}else
		if(!strcmp(P[i].instrucao,"NADA")){
			i++;
		}else
		if(!strcmp(P[i].instrucao,"LEIT")){
			int temp;
			printf(":");
			scanf("%d",&temp);
			s++;
			M[s] = temp;
			i++;
		}else
		if(!strcmp(P[i].instrucao,"PARA")){
			exit(0);
		}else{
			printf("\n\nErro! [%s][%d]\n",P[i].instrucao,P[i].parametro);
		}
		/*statusM();
		printf("%d:%s\t%d\n",i,P[i].instrucao,P[i].parametro);
		*/

	}
	printf("Programa terminado.\n");

	
}
