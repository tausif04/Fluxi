/* Definition Section */
%{
#include <stdio.h>

int yylex(void);
int yyerror(const char *s);
extern FILE *yyin;
%}

%union {
    int num;
}

/* Token */
%token EOL
%token <num> NUMBER
%token PLUS
%type <num> exp
%token MINUS
%token MULTIPLY
%left PLUS MINUS
%left MULTIPLY
%left DIVISION
%token LEFTPAREN
%token RIGHTPAREN
%type <num> fact

%%

input:
     
    |input line
;

line:
    exp EOL {printf("%d \n",$1);}
|   exp {printf("%d \n",$1);}
|   EOL {}
;

exp:
    exp PLUS exp { $$ = $1 + $3; }
|   exp MINUS exp { $$ = $1 - $3; }
|   exp MULTIPLY exp { $$ = $1 * $3; }
|   exp DIVISION exp { $$ = $1 / $3; }
|   fact
;

fact:
    NUMBER { $$ = $1; }
|   LEFTPAREN exp RIGHTPAREN {$$ = $2;} 
%%
/* User Section */
int main(void) {
    yyin = fopen("input.txt", "r");
    int res=yyparse();
    fclose(yyin);
    return res;
}

int yyerror(const char *s) {
    printf("ERROR: %s \n", s);
    return 0;
}