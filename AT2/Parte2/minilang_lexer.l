%{
#include <stdio.h>
#include <stdlib.h>

int linha = 1;
extern FILE *yyin; 
%}

%option noyywrap 

/* Declaracao de um "Estado" para ler comentarios de multiplas linhas */
%x COMENTARIO_MULTI

%%

\n                      { linha++; }
[ \t]+                  { /* ignora espacos e tabulacoes */ }

 /* 1. COMENTARIOS */
"#".*                   { printf("LINHA %d: COMMENT_SINGLE(%s)\n", linha, yytext); }

"\{---"                 { BEGIN(COMENTARIO_MULTI); printf("LINHA %d: COMMENT_MULTI_START(%s)\n", linha, yytext); }
<COMENTARIO_MULTI>"---}" { BEGIN(INITIAL); printf("LINHA %d: COMMENT_MULTI_END(%s)\n", linha, yytext); }
<COMENTARIO_MULTI>\n    { linha++; }
<COMENTARIO_MULTI>.     { /* Ignora o texto dentro do comentario */ }

 /* 2. STRINGS E TEXTOS (Atualizado para o padrao do PDF: `texto') */
\'[^\']*\'|\`[^\']*\'   { printf("LINHA %d: STRING(%s)\n", linha, yytext); }

 /* 3. PALAVRAS RESERVADAS */
"inicio"|"fim"|"inteiro"|"real"|"texto"|"booleano"|"se"|"faz"|"senao"|"repita_enquanto"|"para"|"de"|"ate"|"faca"|"leia"|"mostre"|"sim"|"nao"|"retorne"|"funcao" { 
                            printf("LINHA %d: KEYWORD(%s)\n", linha, yytext); 
                        }

 /* 4. IDENTIFICADORES E REGRA DE ERRO (Variavel comecando com numero) */
[0-9]+[a-zA-Z_][a-zA-Z0-9_]* { printf("LINHA %d: ERROR_INVALID_ID(%s)\n", linha, yytext); }
[a-zA-Z_][a-zA-Z0-9_]*  { printf("LINHA %d: IDENTIFIER(%s)\n", linha, yytext); }

 /* 5. NUMEROS INTEIROS E REAIS (Real usa virgula na MiniLang) */
[0-9]+","[0-9]+         { printf("LINHA %d: REAL(%s)\n", linha, yytext); }
[0-9]+                  { printf("LINHA %d: INTEGER(%s)\n", linha, yytext); }

 /* 6. OPERADORES E DELIMITADORES */
"=="|"!="|"<="|">="|"<"|">" { printf("LINHA %d: RELOP(%s)\n", linha, yytext); }
"&&"|"||"|"!"           { printf("LINHA %d: LOGICAL(%s)\n", linha, yytext); }
"+"|"-"|"*"|"/"|"%"     { printf("LINHA %d: ARITH_OP(%s)\n", linha, yytext); }
"="                     { printf("LINHA %d: ASSIGN(%s)\n", linha, yytext); }

"("|")"|"["|"]"|"{"|"}"|";"|"$" { printf("LINHA %d: DELIMITER(%s)\n", linha, yytext); }

 /* 7. CARACTERES NAO RECONHECIDOS (Erros gerais) */
.                       { printf("LINHA %d: ERROR(%s)\n", linha, yytext); }

%%

int main(int argc, char **argv) {
    if (argc >= 2) {
        FILE *arquivo = fopen(argv[1], "r");
        if (!arquivo) {
            printf("Erro: Nao foi possivel abrir o arquivo '%s'.\n", argv[1]);
            return 1;
        }
        yyin = arquivo;
    } else {
        printf("Aviso: Lendo da entrada padrao...\n");
    }

    yylex();
    return 0;
}