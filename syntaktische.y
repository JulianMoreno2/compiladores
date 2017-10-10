% {
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "baum.c"
#include "tabelle.c"
  int yylex();
  int yyerror(const char *nachricht) { printf("Syntax-Fehler: %s\n", nachricht);}
  %
}


% union {
  struct knoten_as * baum; //Implementar este struct
  char zeichen;
  int ganzzahl;
  char variable[50];
  char typ[10]; // Revisar para que era esta palabra
  float gleitkomma;
}

% token ZEILENENDE

% token <typ> DEFGANZZAHL
% token <typ> DEFGLEITKOMMA
% token <typ> DEFZEICHEN
% token <typ> DEFSTRING
% token <typ> DEFBOOLEAN

% token GLEICH
% token UNGLEICH
% token KOMA
% token GLEICH_GLEICH
% token PUNKT
% token GROSSER_GLEICH
% token KLEINER_GLEICH
% token KLAMMER_OFFEN
% token KLAMMER_SCHLIESSEN
% token GROSSER
% token KLEINER
% token SCHLUOFFEN
% token SCHLUSCHLIESSEN
% token SUMME
% token SUBSTRAKTION
% token MULTIPLIKATION
% token DIVISION
% token AUFGABE
% token UND
% token ODER
% token NICHT

% token MAIN
% token WENN
% right SONNST
% token WAHREND
% token <variable> ZEICHEN
% token <variable> BOOLEAN
% token <variable> VARIABLE
% token <variable> STRING
% token <ganzzahl> GANZZAHL
% token <gleitkomma> GLEITKOMMA

% type <gleitkomma> fsatz
% type <ganzzahl> isatz

% type <baum> aufgabe ausdruck gleitkomma_ausdruck gleitkomma_begriff gleitkomma_faktor gemischte_summe gemischte_ausdruck

% type <baum> program ganzzahl aussage urteil korper ganzzahl_wert ganzzahl_faktor ganzzahl_ausdruck

% %

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
  nodo_as* variable_blatt = neuen_knoten_variable($1);
  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, $3);
} | 
VARIABLE GLEICH ganzzahl_ausdruck ZEILENENDE{
  existieren_kontatieren($1);
  ist_ganzzahl($1);
  nodo_as* variable_blatt = neuen_knoten_variable($1);
  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, $3);
}
| VARIABLE GLEICH VARIABLE ZEILENENDE {
  nodo_as* variable_blatt = neuen_knoten_variable($1);
  nodo_as* v_dos = neuen_knoten_variable($3);
  if (!existieren($1) || !existieren($3)) {
    yyerror("Variable not definiten.");
  }
  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, v_dos);
  compararTipos($1, $3);
}
| VARIABLE GLEICH VARIABLE SUMME VARIABLE ZEILENENDE {
  if (!existieren($1) || !existieren($3) || !existieren($5)) {
    yyerror("Variable not definiten.");
  }
  compararTipos($1, $3);
  compararTipos($1, $5);
  comprobarVariasVariables($1, $3, $5);
  nodo_as* variable_blatt = neuen_knoten_variable($1);
  nodo_as* v_dos = neuen_knoten_variable($3);
  nodo_as* v_tres = neuen_knoten_variable($5);
  nodo_as* suma = neuen_knoten_ausdruck(EXPRESION, "+", v_dos, v_tres);
  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, suma);
}

/**

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

*/

% %

int main () {
  yyparse ();
  return 0;
}
