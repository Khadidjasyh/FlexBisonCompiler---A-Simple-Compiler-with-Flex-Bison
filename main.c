#include <stdio.h>
#include <stdlib.h>
#include "symbol_table.h"

int main() {
    // Initialize the symbol table
    SymbolTable symbolTable;
    initSymbolTable(&symbolTable);

    // Insert some symbols into the table
    insertSymbol(&symbolTable, "var1", TYPE_NUM, VAR_NORMAL);
    insertSymbol(&symbolTable, "var2", TYPE_REAL, VAR_CONSTANT);
    insertSymbol(&symbolTable, "var3", TYPE_TEXT, VAR_NORMAL);
    insertSymbol(&symbolTable, "arr", TYPE_ARRAY_NUM, VAR_NORMAL);

    // Look up and print the symbol information
    SymbolEntry* var1 = lookupSymbol(&symbolTable, "var1");
    if (var1) {
        printf("Found symbol: %s, Type: %d, Property: %d\n", var1->name, var1->type, var1->property);
    } else {
        printf("Symbol 'var1' not found.\n");
    }

    // Print all symbols in the symbol table
    printSymbolTable(&symbolTable);

    // Free the memory used by the symbol table
    freeSymbolTable(&symbolTable);

    return 0;
}