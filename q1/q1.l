%{
#include <stdio.h>
int linhas = 0, palavras = 0, caracteres = 0;
int inteiros = 0, floats = 0, pontuacoes = 0;
%}

%%
[0-9]+\.[0-9]+  { floats++; caracteres += yyleng; }
[0-9]+          { inteiros++; caracteres += yyleng; }
[.,;:!?]        { pontuacoes++; caracteres += yyleng; }
[a-zA-Z]+       { palavras++; caracteres += yyleng; }
\n              { linhas++; caracteres++; }
.               { caracteres++; }
%%

int main(int argc, char **argv) {
    yylex();
    printf("linhas: %d\npalavras: %d\ncaracteres: %d\ninteiros: %d\nfloats: %d\npontuacoes: %d\n",
           linhas, palavras, caracteres, inteiros, floats, pontuacoes);
    return 0;
}

int yywrap() { return 1; }