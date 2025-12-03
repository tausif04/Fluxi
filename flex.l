/* Definition Section */
%{
#include <stdio.h>
#include <stdlib.h>
#include "bison.tab.h"
#include <string.h>

%}
%x COMMENT
/* Rules Section */
%%

"::<" {BEGIN(COMMENT);}
<COMMENT>">::" {BEGIN(INITIAL);}
<COMMENT>.|\n {}
"::"[^<\n][^\n]* {}

[0-9]*\.[0-9]+ {yylval.real=atof(yytext); return FRACTION;}
[0-9]+ { yylval.num=atoi(yytext); return NUMBER; } // convert string to int


num {return INT;}
real {return FLOAT;}
text {return CHAR;}/* [a-zA-Z]+ {yylval.text=yytext; return CHARACTER;} */


[a-z_A-Z_][a-z_A-Z0-9]* {yylval.text=strdup(yytext);return NAME;}

\" {return QUOTE;}
";" {return SEMICOLON;}
"=" {return EQUAL;}
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