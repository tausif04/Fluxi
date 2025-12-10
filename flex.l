/* Definition Section */
%{
#include <stdio.h>
#include <stdlib.h>
#include "bison.tab.h"
#include <string.h>
extern int checkType(char* name);

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

make {return MAKE;}
take {return TAKE;}
num {return INT;}
real {return FLOAT;}
text {return CHAR;}
show {return PRINT;}

[a-z_A-Z_][a-z_A-Z0-9]* {
    yylval.text=strdup(yytext);
    int type = checkType(yytext);

    if (type == 1) {
        return VAR_INT; 
    } else if (type == 2) {
        return VAR_FLOAT;
    } else {
       return NAME;}
    }


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