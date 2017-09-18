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
%token VERSCHIEDENE
%token KOMA
%token VERGLEICH
%token GROBERGLEICH
%token WENIGERGLEICH
%token KLAM_OFFEN
%token KLAM_SCHLIESSEN
%token GROBER
%token WENIGER
%token SCHLUOFFEN
%token SCHLUSCHLIESSEN
%token BESUMME
%token BEMINDES
%token BEMULT
%token BETEI
%token UND
%token ODER
%token NICHT

%token HAUPT
%token WENN
%right ANDERES
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
