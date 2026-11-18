%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

typedef enum {NODE_REAL, NODE_SOMA, NODE_SUB, NODE_DIV, NODE_MULT, NODE_MAIOR, NODE_MENOR, NODE_IGUAL, NODE_DIF, NODE_MAIORQ, NODE_MENORQ, NODE_PRINT, NODE_ATRIB, NODE_BLOCO, NODE_IF, NODE_IMPRIMIR, NODE_VAR, NODE_VALOR_VAR, NODE_IF_ELSE, NODE_WHILE}NodeType;

typedef enum {
    TIPO_INTEIRO,
    TIPO_REAL
} TipoVariavel;

typedef struct ast { /*Estrutura de um nó*/
	int nodetype;
	struct ast *left;
	struct ast *right;
}Ast; 

typedef struct vars { //estrutura de uma variável
    char name[50];
    float valor;
    TipoVariavel tipo;
    struct vars * prox;
} VARI;

typedef struct v_real { /*Estrutura de um número*/
	int nodetype;
	float number;
}ValorReal;

typedef struct nome_var { /*Estrutura de um nome de variável*/
	int nodetype;
	char var[50];
}NomeVariavel;

typedef struct declaracao {
    int nodetype;
    char nome[50];
    TipoVariavel tipo;
} Declaracao;

typedef struct atrib { /*Estrutura para um nó de atribuição. Para atrubior o valor de v em s*/
	int nodetype;
	char s[50];
	Ast *v;
}Atrib;

typedef struct flow { /*Estrutura de um desvio (if/else/while)*/
	int nodetype;
	Ast *cond;		/*condição*/
	Ast *tl;		/*then, ou seja, verdade*/
	Ast *el;		/*else*/
}Flow;

VARI *l1, *aux;
Ast *raiz;

	//insere uma nova variável na lista de variáveis
VARI *ins(VARI *l, char n[], TipoVariavel tipo) {
    VARI *new = (VARI*)malloc(sizeof(VARI));

    strcpy(new->name, n);
    new->valor = 0;
    new->tipo = tipo;

    new->prox = l;

    return new;
}
	
	//busca uma variável na lista de variáveis
	VARI *procurar_var(VARI*l,char n[]){
		VARI*aux = l;
		while(aux != NULL){
			if(strcmp(n,aux->name)==0)
				return aux;
			aux = aux->prox;
		}
		return aux;
	}


Ast * newast(int nodetype, Ast *l, Ast *r){ /*Função para criar um nó*/
	Ast *new = (Ast*) malloc(sizeof(Ast));
	new->nodetype = nodetype;
	new->left = l;
	new->right = r;
	return new;
}
 
Ast * newvalor(float d) {	/*Função de que cria um número (folha)*/
	ValorReal *new = (ValorReal*) malloc(sizeof(ValorReal));
	new->nodetype = NODE_REAL;
	new->number = d;
	return (Ast*)new; /*é necesseário convertar para AST, antes de ser inserido na árvore*/
}

Ast * newvari(int nodetype, char nome[50]) {/*Função de que cria um nó do tipo variável*/
	NomeVariavel *new = (NomeVariavel*) malloc(sizeof(NomeVariavel));
	new->nodetype = nodetype;
	strcpy(new->var,nome);
	return (Ast*)new; /*é necesseário convertar para AST, antes de ser inserido na árvore*/
}

Ast * newflow(int nodetype, Ast *cond, Ast *tl, Ast *el){ /*Função que cria um nó de if/else/while*/
	Flow *new = (Flow*)malloc(sizeof(Flow));
	new->nodetype = nodetype;
	new->cond = cond;
	new->tl = tl; //ponteiro (condição verdade)
	new->el = el; //ponteiro (condição falso)
	return (Ast *)new; /*é necesseário convertar para AST, antes de ser inserido na árvore*/
}

Ast * newcmp(int tipo_op_logica, Ast *l, Ast *r){ /*Função que cria um nó para testes condicionais*/
	Ast *new = (Ast*)malloc(sizeof(Ast));
	switch(tipo_op_logica){/*Para pegar o tipe de teste, definido no arquivo.l e utilizar na função eval()*/
		case 1: new->nodetype = NODE_MAIOR;break;
		case 2: new->nodetype = NODE_MENOR;break;
		case 3: new->nodetype = NODE_MAIORQ;break;
		case 4: new->nodetype = NODE_MENORQ;break;
		case 5: new->nodetype = NODE_IGUAL;break;
		case 6: new->nodetype = NODE_DIF;break;
	}
	new->left = l;
	new->right = r;
	return new;
}

Ast * newatrib(char s[50], Ast *v) { /*Função para um nó de atribuição*/
	Atrib *new = (Atrib*)malloc(sizeof(Atrib));
	new->nodetype = NODE_ATRIB;
	strcpy(new->s,s);
	new->v = v; /*Valor*/
	return (Ast *)new;
}

Ast *newdecl(TipoVariavel tipo, char nome[50]) {
    Declaracao *new = (Declaracao*)malloc(sizeof(Declaracao));

    new->nodetype = NODE_VAR;
    strcpy(new->nome, nome);
    new->tipo = tipo;

    return (Ast*)new;
}

float eval(Ast *a) { /*Função que executa operações a partir de um nó*/
	float v = 0;
	if (!a) {printf("vazio\n"); return 0;}
    switch(a->nodetype) {
		case NODE_REAL: return ((ValorReal*)a)->number; break;
        case NODE_SOMA: return eval(a->left) + eval(a->right); break;
        case NODE_MULT: return eval(a->left) * eval(a->right); break;
		case NODE_IMPRIMIR: v = eval(a->left);		/*Recupera um valor*/
							printf ("%.2f\n",v); break;  /*imprime o valor*/
		case NODE_IF:
						if (eval(((Flow *)a)->cond) == 1) {	/*executa a condição / teste*/
							if (((Flow *)a)->tl)		/*Se existir árvore à esquerda*/
								v = eval(((Flow *)a)->tl); /*Verdade*/
						}
						break;
		case NODE_IF_ELSE:
						if (eval(((Flow *)a)->cond) == 1) {	/*executa a condição / teste*/
							if (((Flow *)a)->tl)		/*Se existir árvore à esquerda*/
								v = eval(((Flow *)a)->tl);

						}
						else{
							if (((Flow *)a)->el)		/*Se existir árvore à esquerda*/
								v = eval(((Flow *)a)->el);

						}
						break;
		case NODE_WHILE:

						while(eval(((Flow *)a)->cond) == 1) {	/*executa a condição / teste*/
							
							if (((Flow *)a)->tl)		/*Se existir árvore à esquerda*/
								v = eval(((Flow *)a)->tl);

						}

						break;
		case NODE_MAIOR: v = (eval(a->left) > eval(a->right))? 1 : 0; break;	/*Operações lógicas. "árv esq   >   árv dir"  Se verdade 1, falso 0*/
		case NODE_MENOR: v = (eval(a->left) < eval(a->right))? 1 : 0; break;
		case NODE_MAIORQ: v = (eval(a->left) >= eval(a->right))? 1 : 0; break;
		case NODE_MENORQ: v = (eval(a->left) <= eval(a->right))? 1 : 0; break;
		case NODE_IGUAL: v = (eval(a->left) == eval(a->right))? 1 : 0; break;
		case NODE_DIF: v = (eval(a->left) != eval(a->right))? 1 : 0; break;
		case NODE_SUB: return eval(a->left) - eval(a->right);
		case NODE_DIV: return eval(a->left) / eval(a->right);
		case NODE_VAR: {
						Declaracao *d = (Declaracao*)a;

						l1 = ins(l1, d->nome, d->tipo);

						break;
		}
		case NODE_ATRIB:	v = eval(((Atrib *)a)->v); /*Recupera o valor*/
							aux = procurar_var(l1,((Atrib *)a)->s);
							aux->valor = v;
							break;
		case NODE_VALOR_VAR:	aux = procurar_var(l1,((NomeVariavel *)a)->var);
								v = aux->valor;
								break;
		case NODE_BLOCO: 	eval(a->left);
							v = eval(a->right);
							break; /*Lista de operções em um bloco IF/ELSE/WHILE. Assim o analisador não se perde entre os blocos*/
		

	}
	return v;
}

int yylex();
void yyerror (char *s){
	printf("%s\n", s);
}

%}

%union{
	float real;
	int op_log;
	char str[100];
	Ast *a;
	}

%token <real>NUM
%token <op_log>CMP
%token <str>VARS
%token IF ELSE PRINT DECL WHILE TIPO_INT TIPO_FLOAT

%right '='
%nonassoc CMP
%left '+' '-'
%left '*' '/'

%type <a> val exp stmt prog list

%%

val: prog {
    raiz = $1;
    $$ = $1;
}
;

prog: stmt {
    $$ = $1;
}
| prog stmt {
    $$ = newast(NODE_BLOCO, $1, $2);
}
;

	/*operações disponíveis*/
stmt:	DECL VARS {$$ = newdecl(TIPO_REAL, $2);}
    | 	TIPO_INT VARS {$$ = newdecl(TIPO_INTEIRO, $2);}
    | 	TIPO_FLOAT VARS {$$ = newdecl(TIPO_REAL, $2);}
	|	VARS '=' exp {$$ = newatrib($1,$3);}
	|	IF '(' exp ')' '{' list '}' {$$ = newflow(NODE_IF, $3, $6, NULL);}
	|	IF '(' exp ')' '{' list '}' ELSE '{' list '}' {$$ = newflow(NODE_IF_ELSE, $3, $6, $10);}
	|   WHILE '(' exp ')' '{' list '}' {$$ = newflow(NODE_WHILE, $3, $6, NULL);}
	| 	PRINT '(' exp ')' {$$ = newast(NODE_IMPRIMIR,$3,NULL);}
	;

exp: exp '+' exp {$$ = newast(NODE_SOMA,$1,$3);}
    | exp '-' exp {$$ = newast(NODE_SUB,$1,$3);}
    | exp '*' exp {$$ = newast(NODE_MULT,$1,$3);}
    | exp '/' exp {$$ = newast(NODE_DIV,$1,$3);}
    | '(' exp ')' {$$ = $2;}
    | exp CMP exp {$$ = newcmp($2,$1,$3);}
    | NUM {$$ = newvalor($1);}
    | VARS {$$ = newvari(NODE_VALOR_VAR,$1);}
    ;

list:		stmt{$$ = $1;}
		| 	list stmt { $$ = newast(NODE_BLOCO, $1, $2);	}
		;

%%

#include "lex.yy.c"

int main(){
    l1 = NULL;
    aux = NULL;
    raiz = NULL;

    yyin = fopen("teste.txt", "r");

    if (yyin == NULL) {
        printf("Erro ao abrir teste.txt\n");
        return 1;
    }

    if (yyparse() == 0) {
        eval(raiz);
    }

    fclose(yyin);

    return 0;
}
