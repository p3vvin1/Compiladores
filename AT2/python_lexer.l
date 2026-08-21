%{
#include <stdio.h>
#include <stdlib.h>

int linha = 1;
%}

%%

\n                      { linha++; }
[ \t]+                  { /* ignora espacos */ }

"#".*                   { printf("LINHA %d: COMMENT(%s)\n", linha, yytext); }

\"[^\"]*\"|\'[^\']*\'   { printf("LINHA %d: STRING(%s)\n", linha, yytext); }

"def"|"if"|"else"|"elif"|"while"|"for"|"in"|"return"|"and"|"or"|"not"|"class"|"import"|"from"|"True"|"False"|"None"|"pass"|"break"|"continue" { 
                            printf("LINHA %d: KEYWORD(%s)\n", linha, yytext); 
                        }

[a-zA-Z_][a-zA-Z0-9_]*  { printf("LINHA %d: IDENTIFIER(%s)\n", linha, yytext); }

[0-9]+\.[0-9]+          { printf("LINHA %d: REAL(%s)\n", linha, yytext); }
[0-9]+                  { printf("LINHA %d: INTEGER(%s)\n", linha, yytext); }

"=="|"!="|"<="|">="     { printf("LINHA %d: RELOP(%s)\n", linha, yytext); }
"="                     { printf("LINHA %d: ASSIGN(%s)\n", linha, yytext); }
"+"|"-"|"*"|"/"|"%"     { printf("LINHA %d: ARITH_OP(%s)\n", linha, yytext); }

"("|")"|"["|"]"|"{"|"}"|":"|","|"." { printf("LINHA %d: DELIMITER(%s)\n", linha, yytext); }

.                       { printf("LINHA %d: ERROR(%s)\n", linha, yytext); }

%%

int main(int argc, char **argv) {
    if (argc >= 2) {
        FILE *arquivo = fopen(argv[1], "r");
        if (!arquivo) {
            printf("Erro: Nao foi possivel abrir o arquivo '%s'.\n", argv[1]);
            return 1;
        }
        extern FILE *yyin;
        yyin = arquivo;
    }

    yylex();
    return 0;
}

int yywrap() {
    return 1;
}