/* Definition Section */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex(void);
int yyerror(const char *s);
extern FILE *yyin;

typedef enum {TYPE_NUM, TYPE_REAL, TYPE_TEXT} Data_type;
struct Symbol {
    char* name;
    Data_type type;
    union{
        int val_num;
        float val_real;
        char* val_text;
    } Data;
};

    struct Symbol symbol_table[100];
    int table_count = 0;

    void storeNum(char* name, int val);
    void storeReal(char* name, float val);
    void storeText(char* name, char* val);
    void showVal(char* name);
    int getNum(char* name);
    float getReal(char* name);
    int checkType (char* name);
    void readInput(int type, char* name);
    
%}

%union {
    int num;
    float real;
    char* text;
}

/* Token */
%token EOL
%token <num> NUMBER
%token <text> CHARACTER
%token <real> FRACTION
%token <text> NAME
%token MAKE
%token TAKE
%token PLUS
%token SEMICOLON
%token QUOTE
%token <text> VAR_INT
%token <text> VAR_FLOAT

%type <num> exp
%type <real> exp2

%token PRINT
%token EQUAL
%token MINUS
%token MULTIPLY
%left PLUS MINUS
%left MULTIPLY
%left DIVISION

%token LEFTPAREN
%token RIGHTPAREN

%type <num> fact
%type <real> fact2

%token INT
%token FLOAT
%token CHAR
%%

input:
     
    |input line
;

line:
    MAKE INT NAME EQUAL exp SEMICOLON EOL {storeNum($3, $5);printf("%d is the value \n",$5);}
|   MAKE INT NAME EQUAL exp SEMICOLON {storeNum($3, $5);printf("%d is the value\n",$5);}
|   MAKE FLOAT NAME EQUAL exp2 SEMICOLON {storeReal($3, $5);printf("%f is the value\n",$5);}
|   MAKE FLOAT NAME EQUAL exp2 SEMICOLON EOL {storeReal($3, $5);printf("%f is the value\n",$5);}
|   MAKE CHAR NAME EQUAL QUOTE NAME QUOTE SEMICOLON {storeText($3, $6);printf("%s is the value \n",$6)}
|   TAKE INT NAME SEMICOLON { readInput(1, $3); }
|   TAKE FLOAT NAME SEMICOLON { readInput(2, $3); }
|   TAKE CHAR NAME SEMICOLON { readInput(3, $3); }
|   TAKE INT NAME SEMICOLON EOL { readInput(1, $3); }
|   TAKE FLOAT NAME SEMICOLON EOL { readInput(2, $3); }
|   TAKE CHAR NAME SEMICOLON EOL { readInput(3, $3); }
|   PRINT LEFTPAREN NAME RIGHTPAREN SEMICOLON {showVal($3);}
|   PRINT LEFTPAREN VAR_INT RIGHTPAREN SEMICOLON {showVal($3);}
|   PRINT LEFTPAREN VAR_FLOAT RIGHTPAREN SEMICOLON {showVal($3);}
|   EOL {}
;

exp:
    exp PLUS exp { $$ = $1 + $3; }
|   exp MINUS exp { $$ = $1 - $3; }
|   exp MULTIPLY exp { $$ = $1 * $3; }
|   exp DIVISION exp { $$ = $1 / $3; }
|   fact;

fact:
    NUMBER { $$ = $1; }
|   VAR_INT   { $$ = getNum($1); }
|   LEFTPAREN exp RIGHTPAREN {$$ = $2;} 

exp2:
    exp2 PLUS exp2 { $$ = $1 + $3; }
|   exp2 MINUS exp2 { $$ = $1 - $3; }
|   exp2 MULTIPLY exp2 { $$ = $1 * $3; }
|   exp2 DIVISION exp2 { $$ = $1 / $3; }
|   exp PLUS exp2 { $$ = $1 + $3; }
|   exp MINUS exp2 { $$ = $1 - $3; }
|   exp MULTIPLY exp2 { $$ = $1 * $3; }
|   exp DIVISION exp2 { $$ = $1 / $3; }
|   exp2 PLUS exp  { $$ = $1 + $3; }
|   exp2 MINUS exp { $$ = $1 - $3; }
|   exp2 MULTIPLY exp { $$ = $1 * $3; }
|   exp2 DIVISION exp { $$ = $1 / $3; }
|   fact2;

fact2:
    FRACTION { $$ = $1; }
|   VAR_FLOAT { $$ = getReal($1); }
|   LEFTPAREN exp2 RIGHTPAREN {$$ = $2;}

%%
/* User Section */

int getIndex(char *name) {
    for(int i = 0; i < table_count; i++) {
        if(strcmp(symbol_table[i].name, name) == 0) {
            return i;
        }
    }
    return -1; 
}
int checkType(char *name) {
    int idx = getIndex(name);
    if (idx == -1) return 0; // Not found
    
    if (symbol_table[idx].type == TYPE_NUM) return 1;
    if (symbol_table[idx].type == TYPE_REAL) return 2;
    return 0;
}
// Store a 'num'
void storeNum(char *name, int val) {
    int idx = getIndex(name);
    if(idx == -1) { idx = table_count++; symbol_table[idx].name = name; }
    
    symbol_table[idx].type = TYPE_NUM;
    symbol_table[idx].Data.val_num = val;
}

// Store a 'real'
void storeReal(char *name, float val) {
    int idx = getIndex(name);
    if(idx == -1) { idx = table_count++; symbol_table[idx].name = name; }
    
    symbol_table[idx].type = TYPE_REAL;
    symbol_table[idx].Data.val_real = val;
}

// Store 'text'
void storeText(char *name, char *val) {
    int idx = getIndex(name);
    if(idx == -1) { idx = table_count++; symbol_table[idx].name = name; }
    
    symbol_table[idx].type = TYPE_TEXT;
    symbol_table[idx].Data.val_text = val;
}

// Retrieve a 'num' for math
int getNum(char *name) {
    int idx = getIndex(name);
    if(idx == -1) { printf("Error: Variable %s not found.\n", name); return 0; }
    return symbol_table[idx].Data.val_num;
}

// Retrieve a 'real' for math
float getReal(char *name) {
    int idx = getIndex(name);
    if(idx == -1) { printf("Error: Variable %s not found.\n", name); return 0.0; }
    return symbol_table[idx].Data.val_real;
}

// Execute the 'show' command
void showVal(char *name) {
    int idx = getIndex(name);
    if(idx == -1) {
        printf("Error: Variable '%s' does not exist.\n", name);
        return;
    }
    
    if(symbol_table[idx].type == TYPE_NUM) {
        printf("%d\n", symbol_table[idx].Data.val_num);
    } else if(symbol_table[idx].type == TYPE_REAL) {
        printf("%f\n", symbol_table[idx].Data.val_real);
    } else if(symbol_table[idx].type == TYPE_TEXT) {
        printf("%s\n", symbol_table[idx].Data.val_text);
    }
}
void readInput(int type, char* name) {
    printf("Enter value for %s: ", name);
    
    if (type == 1) { // INT
        int val;
        scanf("%d", &val);
        storeNum(name, val);
    } 
    else if (type == 2) { // FLOAT
        float val;
        scanf("%f", &val);
        storeReal(name, val);
    } 
    else if (type == 3) { // TEXT
        char buffer[100];
        scanf("%s", buffer); 
        storeText(name, strdup(buffer)); // Use strdup to save the string safely
    }
}
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