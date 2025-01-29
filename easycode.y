

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

// External functions and variables
extern int yylex();
extern int yyline;
extern char* yytext;
extern FILE* yyin;
extern int line_num;
extern int column_num;

// Error handling function
void yyerror(const char* s);

// Global symbol table
SymbolTable symbolTable;

// Type of current declaration
VariableType current_type;
%}

%union {
    int integer;
    float real;
    char* string;
}

// Keywords
%token DEBUT FIN EXECUTION
%token SI ALORS SINON
%token TANTQUE FAIRE
%token FIXE

// Types
%token NUM_TYPE REAL_TYPE TEXT_TYPE

// Operators
%token PLUS MINUS MULTIPLY DIVIDE
%token EQ NE LT LE GT GE
%token AND OR NOT
%token ASSIGN

// Punctuation
%token LBRACE RBRACE COLON LBRACKET RBRACKET 


// I/O
%token AFFICHE LIRE

// Literals and Identifiers
%token <integer> INTEGER_LITERAL
%token <real> REAL_LITERAL
%token <string> STRING IDENTIFIER

// Error token
%token ERROR

// Precedence and Associativity
%left OR
%left AND
%left NOT
%left LT LE GT GE EQ NE
%left PLUS MINUS
%left MULTIPLY DIVIDE
%right NEGATION  /* Si vous avez un opérateur unaire comme - ou ! */


%type <integer> expression

%start program

%%

program:
    DEBUT variable_declarations EXECUTION block FIN
    ;

variable_declarations:
    /* empty */
    | variable_declarations variable_declaration 
    ;

variable_declaration:
    // Regular variable declaration
    type COLON IDENTIFIER ';' {
        // Insert variable into symbol table
        if (!insertSymbol(&symbolTable, $3, current_type, VAR_NORMAL)) {
            yyerror("Variable declaration failed");
        }
       
    }
    // Array declaration
    | type COLON IDENTIFIER LBRACKET INTEGER_LITERAL RBRACKET ';' {
        // Insert array into symbol table
        VariableType array_type;
        if ($5 <= 0) {
            yyerror("Array size must be a positive integer");
        }
        switch(current_type) {
            case TYPE_NUM: array_type = TYPE_ARRAY_NUM; break;
            case TYPE_REAL: array_type = TYPE_ARRAY_REAL; break;
            case TYPE_TEXT: array_type = TYPE_ARRAY_TEXT; break;
            default: 
                yyerror("Invalid array type");
                array_type = TYPE_NUM;
        }
        if (!insertSymbol(&symbolTable, $3, array_type, VAR_NORMAL)) {
            yyerror("Array declaration failed");
        }
        free($3);
    }
    // Constant declaration
    | FIXE type COLON IDENTIFIER EQ literal ';' {
        VariableProperty prop = VAR_CONSTANT;
        if (!insertSymbol(&symbolTable, $4, current_type, prop)) {
            yyerror("Constant declaration failed");
        }
        free($4);
    }
    ;

type:
    NUM_TYPE   { current_type = TYPE_NUM; }
    | REAL_TYPE { current_type = TYPE_REAL; }
    | TEXT_TYPE { current_type = TYPE_TEXT; }
    ;

literal:
    INTEGER_LITERAL
    | REAL_LITERAL
    | STRING
    ;

block:
    LBRACE statements RBRACE
    ;

statements:
    /* empty */
    | statements statement
    ;

statement:
    assignment_statement
    | conditional_statement
    | loop_statement
    | io_statement
    ;

assignment_statement:
    // Variable assignment
    IDENTIFIER ASSIGN expression ';' {
        SymbolEntry* var = lookupSymbol(&symbolTable, $1);
        if (!var) {
            char error[100];
            sprintf(error, "Undeclared variable: %s", $1);
            yyerror(error);
        }
       
    }
    // Array assignment
    | IDENTIFIER LBRACKET expression RBRACKET ASSIGN expression ';' {
        SymbolEntry* var = lookupSymbol(&symbolTable, $1);
        if (!var) {
            char error[100];
            sprintf(error, "Undeclared array: %s", $1);
            yyerror(error);
        }
        free($1);
    }
    ;

conditional_statement:
    SI '(' condition ')' ALORS block SINON block 
    | SI '(' condition ')' ALORS block 
    ;

loop_statement:
    TANTQUE '(' condition ')' FAIRE  block 
    ;

condition:
    expression comparison_operator expression
    | NOT condition
    | condition AND condition
    | condition OR condition
    ;

comparison_operator:
    EQ | NE | LT | LE | GT | GE
    ;


io_statement:
    AFFICHE '(' STRING ',' IDENTIFIER ')' { 
        SymbolEntry* var = lookupSymbol(&symbolTable, $5);  // Lookup the identifier
        if (!var) {
            char error[100];
            sprintf(error, "Undeclared variable: %s", $5);
            yyerror(error);
        }
        printf("%s %s\n", $3, var->value);  // Print the string and the variable value
        free($3);  // Free the string (if dynamically allocated)
    }
    | AFFICHE '(' STRING ')' { 
        printf("Affichage chaîne : %s\n", $3);  // Affiche la chaîne
    }
    | AFFICHE '(' IDENTIFIER ')'{
        SymbolEntry* var = lookupSymbol(&symbolTable, $3);
        if (!var) {
            char error[100];
            sprintf(error, "Undeclared variable: %s", $3);
            yyerror(error);
        }
        free($3);
    }
    | LIRE '(' IDENTIFIER ')' {
        SymbolEntry* var = lookupSymbol(&symbolTable, $3);
        if (!var) {
            char error[100];
            sprintf(error, "Undeclared variable: %s", $3);
            yyerror(error);
        }
        free($3);
    }
;



expression:
    INTEGER_LITERAL { $$ = $1; }
    | IDENTIFIER {
        SymbolEntry* var = lookupSymbol(&symbolTable, $1);
        if (!var) {
            char error[100];
            sprintf(error, "Undeclared variable: %s", $1);
            yyerror(error);
        }
        $$ = 0;  // Par défaut si la variable est inconnue
        free($1);
    }
    | expression PLUS expression { $$ = $1 + $3; }
    | expression MINUS expression { $$ = $1 - $3; }
    | expression MULTIPLY expression { $$ = $1 * $3; }
    | expression DIVIDE expression {
        if ($3 == 0) {
            yyerror("Division by zero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    | LBRACE expression RBRACE { $$ = $2; }
    ;

%%

// Error handling function
void yyerror(const char* s) {
    fprintf(stderr, "Syntax Error at line %d, column %d: %s near '%s'\n", 
            line_num, column_num, s, yytext);
}

// Main function for parsing
int main(int argc, char **argv) {

    // Initialize symbol table
    initSymbolTable(&symbolTable);

    // Check if file is provided
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    // Open input file
    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        fprintf(stderr, "Cannot open input file: %s\n", argv[1]);
        return 1;
    }

    // Set input for lexer
    yyin = input_file;

    // Parse the input
    int parse_result = yyparse();

    // Print symbol table for debugging
    printSymbolTable(&symbolTable);

    // Free symbol table
    freeSymbolTable(&symbolTable);

    // Close input file
    fclose(input_file);

    return parse_result;
}