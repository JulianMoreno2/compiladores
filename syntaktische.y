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

%type <baum> gleitkomma_ausdruck gleitkomma_begriff

%type <baum> ganzzahl_ausdruck ganzzahl_begriff

%type <baum> gemischte_summe gemischte_ausdruck

%%

program: MAIN SCHLUOFFEN korper SCHLUSCHLIESSEN {
  printf("End program! \n");
  $3 -> knotenTyp = MAIN;
  $$ = $3;
}

//---------------------------

korper: urteil korper {
  $$ = neuen_knoten_ausdruck(KORPER, "", $1, $2);}
| urteil {
  $$ = $1;
}

//---------------------------

urteil: aussage {$$ = $1;}
| aufgabe {$$ = $1;}
| gleitkomma_ausdruck {$$ = $1;}
| ganzzahl_ausdruck {$$ = $1;}
| gemischte_summe {$$ = $1;}

//---------------------------

aussage:
DEFGANZZAHL VARIABLE ZEILENENDE  {
  printf("--> DEFGANZZAHL\n");

  knoten_as* variable = 0;
  $$ = variable;
  if (!existieren($2)) {
    hinzufugen($1, $2);
  } else{
    yyerror("Variable existieren.");
  }
} |
DEFGLEITKOMMA VARIABLE ZEILENENDE  {
  printf("--> DEFGLEITKOMMA\n");

  knoten_as* variable = 0 ;
  $$ = variable;
  if (!existieren($2)) {
    hinzufugen($1, $2);
  } else {
    yyerror("Variable existieren.");
  }
} |
DEFZEICHEN VARIABLE ZEILENENDE {
  printf("--> DEFZEICHEN\n");

  knoten_as* variable = 0 ;
  $$ = variable;
  if (!existieren($2)) {
    hinzufugen($1, $2);
  } else {
    yyerror("Variable existieren.");
  }
} |
DEFSTRING VARIABLE ZEILENENDE {
  printf("--> DEFSTRING\n");

  knoten_as* variable = 0 ;
  $$ = variable;
  if (!existieren($2)) {
    hinzufugen($1, $2);
  } else {
    yyerror("Variable existieren.");
  }
} |
DEFBOOLEAN VARIABLE ZEILENENDE {
  printf("--> DEFBOOLEAN\n");

  knoten_as* variable = 0 ;
  $$ = variable;
  if (!existieren($2)) {
    hinzufugen($1, $2);
  } else {
    yyerror("Variable existieren.");
  }
}

//---------------------------

aufgabe:
VARIABLE GLEICH gemischte_ausdruck ZEILENENDE {
  printf("--> VARIABLE=gemischte_ausdruck;\n");

  existieren_kontatieren($1); 
  gleitkomma_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, $3);
} | 
VARIABLE GLEICH gleitkomma_ausdruck ZEILENENDE {
  printf("--> VARIABLE=gleitkomma_ausdruck;\n");

  existieren_kontatieren($1);
  gleitkomma_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, $3);
} |
VARIABLE GLEICH ganzzahl_ausdruck ZEILENENDE {
  printf("--> VARIABLE=ganzzahl_ausdruck;\n");

  existieren_kontatieren($1);
  ganzzahl_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, $3);
} |
VARIABLE GLEICH VARIABLE ZEILENENDE {
  printf("--> VARIABLE=VARIABLE;\n");

  existieren_kontatieren($1);
  existieren_kontatieren($3);
  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* v_dos = neuen_knoten_variable($3);
  typen_vergleichen($1, $3);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, v_dos);  
} |
VARIABLE GLEICH VARIABLE SUMME VARIABLE ZEILENENDE {
  printf("--> VARIABLE = VARIABLE + VARIABLE;\n");

  existieren_kontatieren($1);
  existieren_kontatieren($3);
  existieren_kontatieren($5);
  typen_vergleichen($1, $3);
  typen_vergleichen($1, $5);
  // mehrere_variables_vergleichen($1, $3, $5);
  // mehrere -> varias

  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* v_dos = neuen_knoten_variable($3);
  knoten_as* v_tres = neuen_knoten_variable($5);
  knoten_as* summe = neuen_knoten_ausdruck(AUSDRUCK, "+", v_dos, v_tres);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, summe);
} |
VARIABLE GLEICH VARIABLE SUBSTRAKTION VARIABLE ZEILENENDE {
  printf("--> VARIABLE = VARIABLE - VARIABLE;\n");

  existieren_kontatieren($1);
  existieren_kontatieren($3);
  existieren_kontatieren($5);
  typen_vergleichen($1, $3);
  typen_vergleichen($1, $5);
  // mehrere_variables_vergleichen($1, $3, $5);
  // mehrere -> varias

  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* v_dos = neuen_knoten_variable($3);
  knoten_as* v_tres = neuen_knoten_variable($5);
  knoten_as* substraktion = neuen_knoten_ausdruck(AUSDRUCK, "-", v_dos, v_tres);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, substraktion);
} |
VARIABLE GLEICH VARIABLE MULTIPLIKATION VARIABLE ZEILENENDE {
  printf("--> VARIABLE = VARIABLE * VARIABLE;\n");

  existieren_kontatieren($1);
  existieren_kontatieren($3);
  existieren_kontatieren($5);
  typen_vergleichen($1, $3);
  typen_vergleichen($1, $5);
  // mehrere_variables_vergleichen($1, $3, $5);
  // mehrere -> varias

  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* v_dos = neuen_knoten_variable($3);
  knoten_as* v_tres = neuen_knoten_variable($5);
  knoten_as* multiplikation = neuen_knoten_ausdruck(AUSDRUCK, "*", v_dos, v_tres);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, multiplikation);
} |
VARIABLE GLEICH VARIABLE DIVISION VARIABLE ZEILENENDE {
  printf("--> VARIABLE = VARIABLE / VARIABLE;\n");

  existieren_kontatieren($1);
  existieren_kontatieren($3);
  existieren_kontatieren($5);
  typen_vergleichen($1, $3);
  typen_vergleichen($1, $5);
  // mehrere_variables_vergleichen($1, $3, $5);
  // mehrere -> varias

  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* v_dos = neuen_knoten_variable($3);
  knoten_as* v_tres = neuen_knoten_variable($5);
  knoten_as* division = neuen_knoten_ausdruck(AUSDRUCK, "/", v_dos, v_tres);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, division);
} |
VARIABLE GLEICH ZEICHEN ZEILENENDE {  
  printf("--> VARIABLE=ZEICHEN;\n");

  existieren_kontatieren($1);
  zeichen_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* knoten_zeichen = neuen_knoten_zeichen($3);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, knoten_zeichen);  
} | 
VARIABLE GLEICH STRING ZEILENENDE {  
  printf("--> VARIABLE=STRING;\n");

  existieren_kontatieren($1);
  string_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* knoten_string = neuen_knoten_string($3);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, knoten_string); 
} | 
VARIABLE GLEICH BOOLEAN ZEILENENDE {
  printf("--> VARIABLE=BOOLEAN;\n");

  existieren_kontatieren($1);
  boolean_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* knoten_boolean = neuen_knoten_boolean($3);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, knoten_boolean); 
}

//---------------------------

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

//---------------------------

gleitkomma_ausdruck:
VARIABLE SUMME gleitkomma_begriff {
  printf("--> VARIABLE + gleitkomma_begriff;\n");

  existieren_kontatieren($1);
  gleitkomma_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);

  $$ = neuen_knoten_ausdruck(GLEITKOMMA_AUSDRUCK,"+",variable_blatt,$3);
} |
gleitkomma_ausdruck SUMME gleitkomma_ausdruck {
printf("--> gleitkomma_ausdruck + gleitkomma_ausdruck;\n");
  $$ = neuen_knoten_ausdruck(GLEITKOMMA_AUSDRUCK,"+",$1,$3);
} |
gleitkomma_begriff  {
  printf("--> gleitkomma_begriff;\n");
  $$ = $1;
}

gleitkomma_begriff:
GLEITKOMMA {
  printf("--> GLEITKOMMA\n");
  $$ = neuen_knoten_gleitkomma($1);
}

//---------------------------

ganzzahl_ausdruck:
VARIABLE SUMME ganzzahl_begriff {
  printf("--> VARIABLE + ganzzahl_begriff;\n");

  existieren_kontatieren($1);
  ganzzahl_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);

  $$ = neuen_knoten_ausdruck(GANZZAHL_AUSDRUCK,"+",variable_blatt,$3);
} |
ganzzahl_ausdruck SUMME ganzzahl_begriff {
  printf("--> ganzzahl_ausdruck + ganzzahl_begriff;\n");
  $$ = neuen_knoten_ausdruck(GANZZAHL_AUSDRUCK,"+",$1,$3);
} |
ganzzahl_begriff  {
  printf("--> ganzzahl_begriff;\n");
  $$ = $1;
}

ganzzahl_begriff:
GANZZAHL {
  printf("--> GANZZAHL\n");
  $$ = neuen_knoten_ganzzahl($1);
}

%%

int main () {
  yyparse ();
  return 0;
}
