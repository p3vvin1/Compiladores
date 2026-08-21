%{
#include <stdio.h>
%}

%%
"//".*                  { /* Ignora comentários de linha */ }
"if"                    { printf("IF\n"); }
"else"                  { printf("ELSE\n"); }
"while"                 { printf("WHILE\n"); }
"return"                { printf("RETURN\n"); }
[0-9]+(\.[0-9]+)?       { printf("NUMBER %s\n", yytext); }
[a-zA-Z_][a-zA-Z0-9_]*  { printf("ID %s\n", yytext); }
[ \t\n]+                { /* Ignora espaços, tabulações e quebras de linha */ }
.                       { printf("SIMBOLO %s\n", yytext); }
%%

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Erro: nenhum arquivo passado como argumento.\n");
        return 1;
    }
    
    FILE *arquivo = fopen(argv[1], "r");
    if (!arquivo) {
        fprintf(stderr, "Erro: nao foi possivel abrir o arquivo %s.\n", argv[1]);
        return 1;
    }
    
    yyin = arquivo;
    yylex();
    fclose(arquivo);
    
    return 0;
}
int yywrap() { return 1; }