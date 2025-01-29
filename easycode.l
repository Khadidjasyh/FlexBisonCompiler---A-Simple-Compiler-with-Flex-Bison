
%{
#include <stdlib.h> // Pour malloc
#include <string.h> // Pour strdup
#include <stdio.h>  // Pour fileno

#include "symbol_table.h"
#include "easycode.tab.h"  

extern char* symbol_table_strdup(const char* str);

int line_num = 1;
int column_num = 1;

// Helper macro to update column and line tracking
#define UPDATE_LOCATION \
    do { \
        column_num += yyleng; \
    } while(0)
char* my_strdup(const char* str) {
    size_t len = strlen(str) + 1;
    char* copy = (char*)malloc(len);
    if (copy) {
        memcpy(copy, str, len);
    }
    return copy;
}


%}

%option noyywrap

/* Definitions */
DIGIT           [0-9]
LETTER          [A-Z]
IDENTIFIER      [A-Z][A-Za-z0-9_]*
REAL_NUM        [-]?{DIGIT}+"."{DIGIT}+
INTEGER         [-]?{DIGIT}+
STRING          \"[^"]*\"

/* Exclusive states for comments */
%x SINGLE_LINE_COMMENT
%x MULTI_LINE_COMMENT

%%

 /* Keywords */
"DEBUT"         { UPDATE_LOCATION; return DEBUT; }
"FIN"           { UPDATE_LOCATION; return FIN; }
"EXECUTION"     { UPDATE_LOCATION; return EXECUTION; }
"NUM"           { UPDATE_LOCATION; return NUM_TYPE; }
"REAL"          { UPDATE_LOCATION; return REAL_TYPE; }
"TEXT"          { UPDATE_LOCATION; return TEXT_TYPE; }
"SI"            { UPDATE_LOCATION; return SI; }
"ALORS"         { UPDATE_LOCATION; return ALORS; }
"SINON"         { UPDATE_LOCATION; return SINON; }
"TANTQUE"       { UPDATE_LOCATION; return TANTQUE; }
"FAIRE"         { UPDATE_LOCATION; return FAIRE; }
"FIXE"          { UPDATE_LOCATION; return FIXE; }

 /* Operators */
"<-"            { UPDATE_LOCATION; return ASSIGN; }
"+"             { UPDATE_LOCATION; return PLUS; }
"-"             { UPDATE_LOCATION; return MINUS; }
"*"             { UPDATE_LOCATION; return MULTIPLY; }
"/"             { UPDATE_LOCATION; return DIVIDE; }

 /* Comparison Operators */
"="             { UPDATE_LOCATION; return EQ; }
"!="            { UPDATE_LOCATION; return NE; }
"<"             { UPDATE_LOCATION; return LT; }
"<="            { UPDATE_LOCATION; return LE; }
">"             { UPDATE_LOCATION; return GT; }
">="            { UPDATE_LOCATION; return GE; }

 /* Logical Operators */
"ET"            { UPDATE_LOCATION; return AND; }
"OU"            { UPDATE_LOCATION; return OR; }
"NON"           { UPDATE_LOCATION; return NOT; }

 /* I/O Functions */
"affiche" { UPDATE_LOCATION; return AFFICHE; }
"lire"    { UPDATE_LOCATION; return LIRE; }


 /* Punctuation */
"{"             { UPDATE_LOCATION; return LBRACE; }
"}"             { UPDATE_LOCATION; return RBRACE; }
":"             { UPDATE_LOCATION; return COLON; }
"["             { UPDATE_LOCATION; return LBRACKET; }
"]"             { UPDATE_LOCATION; return RBRACKET; }
";"             { UPDATE_LOCATION; return ';'; }
"("             { UPDATE_LOCATION; return '('; }   
")"             { UPDATE_LOCATION; return ')'; }   
","             { UPDATE_LOCATION; return ','; }


 /* Identifiers */
{IDENTIFIER} {
    UPDATE_LOCATION;
    if (yyleng > 10) {
        fprintf(stderr, "Error: Identifier '%s' exceeds max length of 10\n", yytext);
        return ERROR;
    }
    yylval.string = symbol_table_strdup(yytext);
    return IDENTIFIER;
}

 /* Literals */
{INTEGER} {
    UPDATE_LOCATION;
    yylval.integer = atoi(yytext);
    return INTEGER_LITERAL;
}

{REAL_NUM} {
    UPDATE_LOCATION;
    yylval.real = atof(yytext);
    return REAL_LITERAL;
}

{STRING} {
    UPDATE_LOCATION;
    // Remove quotes
    yytext[yyleng-1] = '\0';
    yylval.string = symbol_table_strdup(yytext + 1);
    return STRING;
}

 /* Comments */
"--" { BEGIN(SINGLE_LINE_COMMENT); }
<SINGLE_LINE_COMMENT>"##" { BEGIN(INITIAL); }
<SINGLE_LINE_COMMENT>.    ;
<SINGLE_LINE_COMMENT>\n   { line_num++; column_num = 1; BEGIN(INITIAL); }

"{-" { BEGIN(MULTI_LINE_COMMENT); }
<MULTI_LINE_COMMENT>"-}" { BEGIN(INITIAL); }
<MULTI_LINE_COMMENT>\n   { line_num++; column_num = 1; }
<MULTI_LINE_COMMENT>.    ;


 /* Whitespace and Newlines */
[ \t]+          { UPDATE_LOCATION; }
\n              { line_num++; column_num = 1; }

. {
    fprintf(stderr, "Lexical Error at line %d, column %d: Unexpected character '%s'\n", 
            line_num, column_num, yytext);
    return ERROR;
}


%%