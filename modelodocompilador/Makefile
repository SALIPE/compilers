# *---------------------------------------------------
# * Compilador PASCAL SIMPLIFICADO PARA MEPA v2023.2
# * 
# * sintatico.y
# *
# * Autor: Fabio Fernandes da Rocha Vicente
# *---------------------------------------------------

all:  gera compila maquina 

gera:
	bison sintatico.y -d
	flex -i -o lexico.c lexico.y
	bison sintatico.y -o sintatico.c

compila:
	gcc sintatico.c -o pascal.exe

testa1:
	./pascal.exe programa.pas
testa2:
	./mepa.exe	programa.pas.mep


maquina:
	gcc mepasimples.c -o mepa.exe

limpa:
	rm -f	pascal.exe
	rm -f 	*.mep
	rm -f 	*.tab.*
	rm -f   lexico.c sintatico.c
	rm  mepa.exe
	ls -lh

	

