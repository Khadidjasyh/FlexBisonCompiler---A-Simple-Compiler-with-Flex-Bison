
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     DEBUT = 258,
     FIN = 259,
     EXECUTION = 260,
     SI = 261,
     ALORS = 262,
     SINON = 263,
     TANTQUE = 264,
     FAIRE = 265,
     FIXE = 266,
     NUM_TYPE = 267,
     REAL_TYPE = 268,
     TEXT_TYPE = 269,
     PLUS = 270,
     MINUS = 271,
     MULTIPLY = 272,
     DIVIDE = 273,
     EQ = 274,
     NE = 275,
     LT = 276,
     LE = 277,
     GT = 278,
     GE = 279,
     AND = 280,
     OR = 281,
     NOT = 282,
     ASSIGN = 283,
     LBRACE = 284,
     RBRACE = 285,
     COLON = 286,
     LBRACKET = 287,
     RBRACKET = 288,
     AFFICHE = 289,
     LIRE = 290,
     INTEGER_LITERAL = 291,
     REAL_LITERAL = 292,
     STRING = 293,
     IDENTIFIER = 294,
     ERROR = 295,
     NEGATION = 296
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 27 "easycode.y"

    int integer;
    float real;
    char* string;



/* Line 1676 of yacc.c  */
#line 101 "easycode.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


