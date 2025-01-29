#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

// Hash function
unsigned int hash(const char* key) {
    unsigned int hash = 0;
    while (*key) {
        hash = (hash * 31) + *key++;
    }
    return hash % HASH_TABLE_SIZE;
}

char* symbol_table_strdup(const char* str) {
    size_t len = strlen(str) + 1;
    char* copy = (char*)malloc(len);
    if (copy) {
        memcpy(copy, str, len);
    }
    return copy;
}


// Initialize symbol table
void initSymbolTable(SymbolTable* symbolTable) {
    for (int i = 0; i < HASH_TABLE_SIZE; i++) {
        symbolTable->table[i] = NULL;
    }
}

// Insert symbol into the table
int insertSymbol(SymbolTable* symbolTable, const char* name, VariableType type, VariableProperty property) {
    // Check for duplicate and length
    if (strlen(name) > MAX_IDENTIFIER_LENGTH) {
        fprintf(stderr, "Error: Identifier '%s' exceeds max length of %d\n", name, MAX_IDENTIFIER_LENGTH);
        return 0;
    }

    SymbolEntry* existing = lookupSymbol(symbolTable, name);
    if (existing != NULL) {
        fprintf(stderr, "Error: Variable '%s' already declared\n", name);
        return 0;
    }

    // Create new symbol entry
    SymbolEntry* newEntry = malloc(sizeof(SymbolEntry));
    strcpy(newEntry->name, name);
    newEntry->type = type;
    newEntry->property = property;
    newEntry->next = NULL;

    // Initialize value based on type
    switch(type) {
        case TYPE_NUM:
            newEntry->value.int_value = 0;
            break;
        case TYPE_REAL:
            newEntry->value.real_value = 0.0;
            break;
        case TYPE_TEXT:
            newEntry->value.text_value[0] = '\0';
            break;
        default:
            // For array types, we might want to add more sophisticated initialization
            newEntry->value.array_data.data = NULL;
            newEntry->value.array_data.size = 0;
    }

    // Insert into hash table
    unsigned int index = hash(name);
    newEntry->next = symbolTable->table[index];
    symbolTable->table[index] = newEntry;

    return 1;
}

// Lookup symbol in the table
SymbolEntry* lookupSymbol(SymbolTable* symbolTable, const char* name) {
    unsigned int index = hash(name);
    SymbolEntry* current = symbolTable->table[index];

    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

// Print symbol table contents
void printSymbolTable(SymbolTable* symbolTable) {
    printf("Symbol Table Contents:\n");
    for (int i = 0; i < HASH_TABLE_SIZE; i++) {
        SymbolEntry* current = symbolTable->table[i];
        while (current != NULL) {
            printf("Name: %s, Type: %d, Property: %d\n", 
                   current->name, current->type, current->property);
            current = current->next;
        }
    }
}

// Free symbol table memory
void freeSymbolTable(SymbolTable* symbolTable) {
    for (int i = 0; i < HASH_TABLE_SIZE; i++) {
        SymbolEntry* current = symbolTable->table[i];
        while (current != NULL) {
            SymbolEntry* temp = current;
            current = current->next;
            free(temp);
        }
        symbolTable->table[i] = NULL;
    }
}











