#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define MAX_IDENTIFIER_LENGTH 10
#define HASH_TABLE_SIZE 100
#define MAX_ARRAY_SIZE 100

// Déclaration de la fonction symbol_table_strdup
char* symbol_table_strdup(const char* str);

// Enum for variable types
typedef enum {
    TYPE_NUM,    // Integer
    TYPE_REAL,   // Floating point
    TYPE_TEXT,   // String
    TYPE_ARRAY_NUM,
    TYPE_ARRAY_REAL,
    TYPE_ARRAY_TEXT
} VariableType;

// Enum for variable properties
typedef enum {
    VAR_NORMAL,
    VAR_CONSTANT
} VariableProperty;

// Symbol table entry structure
typedef struct SymbolEntry {
    char name[MAX_IDENTIFIER_LENGTH];
    VariableType type;
    VariableProperty property;
    union {
        int int_value;
        float real_value;
        char text_value[100];
        struct {
            void* data;
            int size;
        } array_data;
    } value;
    struct SymbolEntry* next;
} SymbolEntry;

// Symbol Table Structure
typedef struct {
    SymbolEntry* table[HASH_TABLE_SIZE];
} SymbolTable;

// Function Prototypes
unsigned int hash(const char* key);
void initSymbolTable(SymbolTable* symbolTable);
int insertSymbol(SymbolTable* symbolTable, const char* name, VariableType type, VariableProperty property);
SymbolEntry* lookupSymbol(SymbolTable* symbolTable, const char* name);
void printSymbolTable(SymbolTable* symbolTable);
void freeSymbolTable(SymbolTable* symbolTable);

#endif // SYMBOL_TABLE_H











