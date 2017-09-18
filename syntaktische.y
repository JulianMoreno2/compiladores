%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "tabla.c"
#include "arbol.c"
int yylex(); 
int yyerror(const char *nachricht) { printf("Syntax-Fehler: %s\n",nachricht);}
%}


%union {
    struct knoten_as * ast;
    char char;
    int nummer;
    char variable[50];
    char art[10];
    float float;
}

%token ZEILENENDE

%token <tipo> DEFINTEGER
%token <tipo> DEFFLOAT
%token <tipo> DEFCHAR
%token <tipo> DEFSTRING
%token <tipo> DEFBOOLEAN

%token GLEICH
%token UNGLEICH
%token KOMA
%token GLEICH_GLEICH
%token PUNKT
%token GROSSER_GLEICH
%token KLEINER_GLEICH
%token KLAMMER_OFFEN
%token KLAMMER_SCHLIESSEN
%token GROSSER
%token KLEINER
%token SCHLUOFFEN
%token SCHLUSCHLIESSEN
%token SUMME
%token SUBSTRAKTION
%token MULTIPLIKATION
%token DIVISION
%token UND
%token ODER
%token NICHT

%token MAIN
%token WENN
%right SONNST
%token WAHREND
%token <variable>CHARACTER
%token <variable>BOOLEAN
%token <variable>VARIABLE
%token <variable>STRING

%token <nummer> INTEGER
%token <float> FLOAT


%type <ast> korper
 
%type <ast> 

%%

programa: HAUPT SCHLUOFFEN korper SCHLUSCHLIESSEN {   

                                                  }
