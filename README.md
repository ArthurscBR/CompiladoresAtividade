# Compilador com AST

Projeto acadêmico de implementação de um compilador utilizando **Flex** e **Bison**, com construção e execução de uma **Árvore Sintática Abstrata (AST — Abstract Syntax Tree)**.

O projeto permite interpretar expressões matemáticas, declarar variáveis, realizar atribuições e executar estruturas de controle, como condicionais e repetições.

## Tecnologias utilizadas

- **C:** implementação das estruturas de dados e execução da AST.
- **Flex:** análise léxica e reconhecimento dos tokens.
- **Bison:** análise sintática e construção da árvore sintática abstrata.
- **Make:** automatização do processo de compilação.

## Funcionalidades

### 1. Declaração de variáveis

A linguagem permite declarar variáveis utilizando três palavras reservadas:

| Comando | Tipo |
|---|---|
| `int` | Inteiro |
| `float` | Real |
| `var` | Real (declaração genérica) |

Exemplo:

```txt
int idade
float altura
var resultado
```

### 2. Atribuição de valores

É possível atribuir valores às variáveis utilizando o operador `=`.

```txt
int numero

numero = 10
```

### 3. Operações matemáticas

O compilador reconhece as seguintes operações:

| Operador | Operação |
|---|---|
| `+` | Adição |
| `-` | Subtração |
| `*` | Multiplicação |
| `/` | Divisão |

Exemplo:

```txt
int a
int b

a = 10
b = 5

escreva(a + b)
escreva(a - b)
escreva(a * b)
escreva(a / b)
```

### 4. Operadores relacionais

São utilizados para realizar comparações em estruturas condicionais e de repetição.

| Operador | Significado |
|---|---|
| `>` | Maior que |
| `<` | Menor que |
| `>=` | Maior ou igual |
| `<=` | Menor ou igual |
| `==` | Igual |
| `!=` | Diferente |

### 5. Estruturas condicionais

A linguagem possui as estruturas `SE` e `SENAO`.

Exemplo:

```txt
int idade

idade = 18

SE (idade >= 18) {
    escreva(1)
} SENAO {
    escreva(0)
}
```

### 6. Estruturas de repetição

A estrutura `repete` permite executar um bloco de instruções enquanto uma condição for verdadeira.

Exemplo:

```txt
int contador

contador = 5

repete (contador > 0) {
    escreva(contador)
    contador = contador - 1
}
```

### 7. Impressão de valores

O comando `escreva()` permite exibir o resultado de expressões matemáticas e valores armazenados em variáveis.

```txt
int numero

numero = 25

escreva(numero)
escreva(numero * 2)
```

## Estrutura do projeto

```text
compiladores2/
│
├── lexico.l          # Regras do analisador léxico (Flex)
├── sintatico.y       # Gramática e implementação da AST (Bison)
├── teste.txt         # Código-fonte utilizado para testes
├── makefile          # Automatização da compilação
│
├── lex.yy.c          # Código gerado pelo Flex
├── sintatico.tab.c   # Código gerado pelo Bison
│
├── analisador        # Executável gerado
│
└── .vscode/          # Configurações do ambiente de desenvolvimento
```

Os arquivos `lex.yy.c` e `sintatico.tab.c` são gerados automaticamente durante a compilação.

## Como executar o projeto

### Pré-requisitos

É necessário possuir as seguintes ferramentas instaladas:

- GCC
- Flex
- Bison
- Make

No Ubuntu ou em distribuições baseadas em Debian, a instalação pode ser feita com:

```bash
sudo apt update

sudo apt install gcc flex bison make
```

### 1. Clonar o repositório

```bash
git clone URL_DO_REPOSITORIO
```

Entre na pasta do projeto:

```bash
cd compiladores2
```

### 2. Preparar o código de teste

O compilador utiliza o arquivo `teste.txt` como entrada.

Edite esse arquivo e escreva o programa que deseja executar utilizando a sintaxe da linguagem.

### 3. Compilar e executar

Execute:

```bash
make
```

O Makefile realiza automaticamente as seguintes etapas:

1. Executa o Flex para gerar o analisador léxico.
2. Executa o Bison para gerar o analisador sintático.
3. Utiliza o GCC para compilar o analisador.
4. Executa o programa gerado.

Caso queira executar as etapas manualmente:

```bash
flex -i lexico.l
bison sintatico.y
gcc sintatico.tab.c -o analisador -lfl -lm
./analisador
```

## Exemplo completo

O exemplo abaixo demonstra a utilização de diferentes recursos da linguagem:

```txt
int x
int y
float resultado

x = 10
y = 5

resultado = x + y

escreva(resultado)

SE (x > y) {
    escreva(x)
} SENAO {
    escreva(y)
}

repete (x > 5) {
    x = x - 1
}

escreva(x)
```

### Saída esperada

```text
15.00
10.00
5.00
5.00
```

## Funcionamento interno

O compilador utiliza duas etapas principais de análise:

**1. Análise léxica**

Realizada pelo Flex, identifica os elementos do código-fonte, como números, identificadores, operadores e palavras reservadas.

**2. Análise sintática e construção da AST**

Realizada pelo Bison, verifica se os tokens seguem as regras da gramática e constrói uma Árvore Sintática Abstrata.

Após a análise sintática, a função `eval()` percorre a AST e executa as operações e estruturas de controle representadas pelos nós.

## Árvore Sintática Abstrata (AST)

A AST representa a estrutura lógica do programa por meio de nós que identificam diferentes operações e instruções.

Entre os tipos de nós implementados estão:

- Operações matemáticas;
- Operadores relacionais;
- Declarações de variáveis;
- Atribuições;
- Impressões;
- Blocos de instruções;
- Estruturas condicionais;
- Estruturas de repetição.

Essa representação permite separar a análise da estrutura do programa de sua execução.

## Observações

- O arquivo de entrada utilizado pelo executável é `teste.txt`.
- As palavras reservadas são sensíveis a maiúsculas e minúsculas conforme definidas no analisador léxico.
- A gramática atual não utiliza ponto e vírgula como terminador obrigatório de instruções.
- A implementação utiliza uma AST para representar e executar as instruções reconhecidas.

## Objetivo acadêmico

O projeto tem como objetivo aplicar conceitos fundamentais da construção de compiladores, especialmente análise léxica, análise sintática, construção de árvores sintáticas abstratas e interpretação de programas.

---

**Projeto desenvolvido para fins acadêmicos — disciplina de Compiladores.**
