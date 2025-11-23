/* Definition Section */
%{
#include <stdio.h>
#include <stdlib.h>
#include "bison.tab.h"

%}
/* Rules Section */
%%
[0-9]+ { yylval.num=atoi(yytext); return NUMBER; } // convert string to int
"+" { return PLUS; }
"-" { return MINUS; }
"*" { return MULTIPLY;}
"/" { return DIVISION;}
"(" {return LEFTPAREN;}
")" {return RIGHTPAREN;}

\n { return EOL; }
[ \t\r]+ {}
. { printf("Unknown character: %s\n", yytext);}

%%

int yywrap(void) { return 1; }