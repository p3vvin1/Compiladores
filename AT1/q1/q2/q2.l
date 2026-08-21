%{
#include <stdio.h>
%}

%%
[0-9]+          { printf("NUMBER %s\n", yytext); }
\+              { printf("PLUS\n"); }
\-              { printf("MINUS\n"); }
\*              { printf("TIMES\n"); }
\/              { printf("DIVIDE\n"); }
\|              { printf("ABS\n"); }
\(              { printf("LPAREN\n"); }
\)              { printf("RPAREN\n"); }
\%              { printf("MOD\n"); }
\^              { printf("POWER\n"); }
"<="            { printf("REL_OP <=\n"); }
">="            { printf("REL_OP >=\n"); }
"=="            { printf("REL_OP ==\n"); }
"!="            { printf("REL_OP !=\n"); }
"<"             { printf("REL_OP <\n"); }
">"             { printf("REL_OP >\n"); }
\n              { printf("NEWLINE\n"); }
[ \t]+          { /* Ignora espaços e tabulações */ }
.               { printf("Mystery character %s\n", yytext); }
%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}
int yywrap() { return 1; }