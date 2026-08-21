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
    yylex();
    return 0;
}
int yywrap() { return 1; }