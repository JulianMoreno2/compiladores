%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "baum.c"
#include "tabelle.c"

int yylex();
int yyerror(const char *nachricht) { printf("Syntax-Fehler: %s\n", nachricht);}

%}

%union {
  struct knoten_as * baum; //Implementar este struct
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
%token AUFGABE
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

%type <baum> program aufgabe aussage ausdruck urteil korper

%type <baum> gleitkomma_ausdruck gleitkomma_begriff gleitkomma_faktor gleitkomma_wert

%type <baum> ganzzahl_ausdruck ganzzahl_begriff ganzzahl_faktor ganzzahl_wert

%type <baum> gemischte_summe gemischte_ausdruck

%%

program: MAIN SCHLUOFFEN korper SCHLUSCHLIESSEN {
  printf("End korper! \n");
  $3 -> knotenTyp = MAIN;
  $$ = $3;
}

korper: urteil korper {
  $$ = neuen_knoten_ausdruck(KORPER, "", $1, $2);}

| urteil {
  $$ = $1;
}

urteil: aussage {$$ = $1;}
| aufgabe {$$ = $1;}
| gleitkomma_ausdruck {$$ = $1;}
| ganzzahl_ausdruck {$$ = $1;}
| gemischte_summe {$$ = $1;}

aussage:
DEFGANZZAHL VARIABLE ZEILENENDE  {
  knoten_as* variable = 0;
  $$ = variable;
  if (!existieren($2)) {
    hinzufugen($1, $2);
  } else{
    yyerror("Variable existieren.");
  }
} |
DEFGLEITKOMMA VARIABLE ZEILENENDE  {
  knoten_as* variable = 0 ;
  $$ = variable;
  if (!existieren($2)) {
    hinzufugen($1, $2);
  } else {
    yyerror("Variable existieren.");
  }
}

aufgabe: 
VARIABLE GLEICH gleitkomma_ausdruck ZEILENENDE {
  existieren_kontatieren($1);
  ist_gleitkomma($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);
  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, $3);
} | 
VARIABLE GLEICH gemischte_ausdruck ZEILENENDE{
  existieren_kontatieren($1); 
  ist_gleitkomma($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);
  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, $3);
} | 
VARIABLE GLEICH ganzzahl_ausdruck ZEILENENDE{
  existieren_kontatieren($1);
  ist_ganzzahl($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);
  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, $3);
} |
VARIABLE GLEICH VARIABLE ZEILENENDE {
  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* v_dos = neuen_knoten_variable($3);
  if (!existieren($1) || !existieren($3)) {
    yyerror("Variable not definiten.");
  }
  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, v_dos);
  typen_vergleichen($1, $3);
} |
VARIABLE GLEICH VARIABLE SUMME VARIABLE ZEILENENDE {
  if (!existieren($1) || !existieren($3) || !existieren($5)) {
    yyerror("Variable not definiten.");
  }

  typen_vergleichen($1, $3);
  typen_vergleichen($1, $5);
  // mehrere_variables_vergleichen($1, $3, $5);
  // mehrere -> varias

  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* v_dos = neuen_knoten_variable($3);
  knoten_as* v_tres = neuen_knoten_variable($5);
  knoten_as* summe = neuen_knoten_ausdruck(AUSDRUCK, "+", v_dos, v_tres);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, summe);
}

gemischte_ausdruck:
gemischte_summe {
  $$ = $1;
}

gemischte_summe:
ganzzahl_ausdruck SUMME gleitkomma_ausdruck {
  $$ = neuen_knoten_ausdruck(GEMISCHTE_SUMME,"+",$1,$3);
} |
gleitkomma_ausdruck SUMME ganzzahl_ausdruck {
  $$ = neuen_knoten_ausdruck(GEMISCHTE_SUMME,"+",$1,$3);
}

gleitkomma_ausdruck:
gleitkomma_ausdruck SUMME gleitkomma_begriff {
  $$ = neuen_knoten_ausdruck(GLEITKOMMA_AUSDRUCK,"+",$1,$3);
} |
gleitkomma_begriff  {
  $$ = $1;
}

gleitkomma_begriff:
gleitkomma_faktor {
  $$ = $1;
}

gleitkomma_faktor: GLEITKOMMA {
  $$ = neuen_knoten_gleitkomma($1);
} |
SCHLUOFFEN gleitkomma_ausdruck SCHLUSCHLIESSEN {
  struct nodo_as* leer = 0;
  $$ = neuen_knoten_ausdruck(GLEITKOMMA_FAKTOR ,"+", leer , $2);
}

ganzzahl_ausdruck:
ganzzahl_ausdruck SUMME ganzzahl_begriff {
  $$ = neuen_knoten_ausdruck(GANZZAHL_AUSDRUCK,"+",$1,$3);
} |
ganzzahl_begriff  {
  $$ = $1;
}

ganzzahl_begriff:
ganzzahl_faktor  {
  $$ = $1;
}

ganzzahl_faktor: GANZZAHL{
  $$ = neuen_knoten_ganzzahl($1);
} |
SCHLUOFFEN ganzzahl_ausdruck SCHLUSCHLIESSEN {
  $$ = $2;
}

%%

int main () {
  yyparse ();
  return 0;
}
