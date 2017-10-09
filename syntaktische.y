%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
int yylex();
int yyerror(const char *nachricht) { printf("Syntax-Fehler: %s\n",nachricht);}
%}


%union {
    struct knoten_as * ast; //Implementar este struct
    char zeichen;
    int ganzzahl;
    char variable[50];
    char typ[10]; // Revisar para que era esta palabra
    float gleitkomma;
}

%token ZEILENENDE

%token <typ> DEFGANZZAHL
%token <typ> DEFGLEITKOMMA
%token <typ> DEFZEICHEN
%token <typ> DEFSTRING
%token <typ> DEFBOOLEAN

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
%token <variable> ZEICHEN
%token <variable> BOOLEAN
%token <variable> VARIABLE
%token <variable> STRING
%token <ganzzahl> GANZZAHL
%token <gleitkomma> GLEITKOMMA

%type <ast> program
%type <gleitkomma> fsatz
%type <ganzzahl> isatz
%type <zeichen> korper

%%

program: MAIN SCHLUOFFEN korper SCHLUSCHLIESSEN {
  printf("End korper! \n");
}

korper:
  fsatz {
    $$ = $1;
    printf("Gleitkomma: %f \n", $1);
  }
|
  isatz {
    $$ = $1;
    printf("Ganzzahl: %i \n", $1);
  }


fsatz: GLEITKOMMA     { $$ = $1; }
  | fsatz SUMME fsatz { $$ = $1 + $3; }
;

isatz: GANZZAHL       { $$ = $1; }
  | isatz SUMME isatz { $$ = $1 + $3; }
;


%%

int main (){
  yyparse ();
  return 0;
}
