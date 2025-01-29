#include "symbol_table.h"

int main() {
    SymbolTable symbolTable;
    initSymbolTable(&symbolTable);

    // Insert some symbols into the symbol table
    insertSymbol(&symbolTable, "var1", TYPE_NUM, VAR_NORMAL);
    insertSymbol(&symbolTable, "var2", TYPE_REAL, VAR_CONSTANT);

    // Print the symbol table
    printSymbolTable(&symbolTable);

    // Free symbol table memory
    freeSymbolTable(&symbolTable);

    return 0;
}
