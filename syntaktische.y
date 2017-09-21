%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
int yylex();
int yyerror(const char *nachricht) { printf("Syntax-Fehler: %s\n",nachricht);}
%}


%union {
    struct knoten_as * ast;
    char charakter;
    int nummer;
    char variable[50];
    char art[10];
    float schwimmende;
}

%token ZEILENENDE

%token <art> DEFINTEGER
%token <art> DEFSCHWIMMENDE
%token <art> DEFCHARAKTER
%token <art> DEFSTRING
%token <art> DEFBOOLEAN

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
%token <variable> CHARAKTER
%token <variable> BOOLEAN
%token <variable> VARIABLE
%token <variable> STRING
%token <nummer> INTEGER
%token <schwimmende> SCHWIMMENDE

%type <ast> program korper satz

%%

program: MAIN SCHLUOFFEN korper SCHLUSCHLIESSEN {
	printf("HALLO!");
  $$ = $3;
}

korper: satz  {
		$$ = $1;
}

satz: {
	printf("SALTEN STRUJEN BAJEN");
}
;

%%

int main (){
    yyparse ();
    return 0;
}
