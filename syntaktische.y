%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "baum.c"
#include "tabelle.c"

int yylex();
int yyerror(const char *nachricht) { 
  printf("Syntax-Fehler: %s\n", nachricht);
}

%}

%union {
  struct knoten_as * baum;
  char zeichen;
  int ganzzahl;
  float gleitkomma;
  char variable[50];
  char typ[10];
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
%token BEDINGUNG
%token UND
%token ODER
%token NICHT

%token GENERATE
%token MAIN
%token WENN
%right SONNST
%token WAHREND
%token FUR
%token <variable> ZEICHEN
%token <variable> BOOLEAN
%token <variable> VARIABLE
%token <variable> STRING
%token <ganzzahl> GANZZAHL
%token <gleitkomma> GLEITKOMMA

%type <baum> generate program aufgabe aussage ausdruck urteil korper

%type <baum> gleitkomma_ausdruck gleitkomma_begriff

%type <baum> ganzzahl_ausdruck ganzzahl_begriff

%type <baum> gemischte_summe gemischte_ausdruck

%type <baum> wenn_urteil bedingung wahrend_urteil fur_urteil fur_ausdruck

//Bedingung = Condicion

%%

generate: GENERATE SCHLUOFFEN program SCHLUSCHLIESSEN {
  generate_intermediate_code($3);
  $$ = $3;
}

program: MAIN SCHLUOFFEN korper SCHLUSCHLIESSEN {
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

urteil:
aussage {$$ = $1;} |
aufgabe {$$ = $1;} |
gleitkomma_ausdruck {$$ = $1;} |
ganzzahl_ausdruck {$$ = $1;} |
gemischte_summe {$$ = $1;} |
wenn_urteil {$$ = $1;} |
wahrend_urteil {$$ = $1;} |
fur_urteil {$$ = $1;}

//---------------------------

aussage:
DEFGANZZAHL VARIABLE ZEILENENDE  {
  knoten_as* variable = neuen_knoten_def(34,$2);
  $$ = variable;
  if (!existieren($2)) {
    hinzufugen($1, $2);
  } else{
    yyerror("Variable existieren.");
  }
} |
DEFGLEITKOMMA VARIABLE ZEILENENDE  {
  knoten_as* variable = neuen_knoten_def(35,$2);
  $$ = variable;
  if (!existieren($2)) {
    hinzufugen($1, $2);
  } else {
    yyerror("Variable existieren.");
  }
} |
DEFZEICHEN VARIABLE ZEILENENDE {
  knoten_as* variable = neuen_knoten_def(36,$2);
  $$ = variable;
  if (!existieren($2)) {
    hinzufugen($1, $2);
  } else {
    yyerror("Variable existieren.");
  }
} |
DEFSTRING VARIABLE ZEILENENDE {
  knoten_as* variable = neuen_knoten_def(37,$2);
  $$ = variable;
  if (!existieren($2)) {
    hinzufugen($1, $2);
  } else {
    yyerror("Variable existieren.");
  }
} |
DEFBOOLEAN VARIABLE ZEILENENDE {
  

  knoten_as* variable = neuen_knoten_def(38,$2);
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
  

  existieren_kontatieren($1);
  gleitkomma_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, $3);
} |
VARIABLE GLEICH gleitkomma_ausdruck ZEILENENDE {
  

  existieren_kontatieren($1);
  gleitkomma_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, $3);
} |
VARIABLE GLEICH ganzzahl_ausdruck ZEILENENDE {
  

  existieren_kontatieren($1);
  ganzzahl_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, $3);
} |
VARIABLE GLEICH VARIABLE ZEILENENDE {
  

  existieren_kontatieren($1);
  existieren_kontatieren($3);
  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* v_zwei = neuen_knoten_variable($3);
  typen_vergleichen($1, $3);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, v_zwei);
} |
VARIABLE GLEICH VARIABLE SUMME VARIABLE ZEILENENDE {
  

  existieren_kontatieren($1);
  existieren_kontatieren($3);
  existieren_kontatieren($5);
  typen_vergleichen($1, $3);
  typen_vergleichen($1, $5);
  // mehrere_variables_vergleichen($1, $3, $5);
  // mehrere -> varias

  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* v_zwei = neuen_knoten_variable($3);
  knoten_as* v_drei = neuen_knoten_variable($5);
  knoten_as* summe = neuen_knoten_ausdruck(AUSDRUCK, "+", v_zwei, v_drei);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, summe);
} |
VARIABLE GLEICH VARIABLE SUBSTRAKTION VARIABLE ZEILENENDE {
  

  existieren_kontatieren($1);
  existieren_kontatieren($3);
  existieren_kontatieren($5);
  typen_vergleichen($1, $3);
  typen_vergleichen($1, $5);
  // mehrere_variables_vergleichen($1, $3, $5);
  // mehrere -> varias

  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* v_zwei = neuen_knoten_variable($3);
  knoten_as* v_drei = neuen_knoten_variable($5);
  knoten_as* substraktion = neuen_knoten_ausdruck(AUSDRUCK, "-", v_zwei, v_drei);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, substraktion);
} |
VARIABLE GLEICH VARIABLE MULTIPLIKATION VARIABLE ZEILENENDE {
  

  existieren_kontatieren($1);
  existieren_kontatieren($3);
  existieren_kontatieren($5);
  typen_vergleichen($1, $3);
  typen_vergleichen($1, $5);
  // mehrere_variables_vergleichen($1, $3, $5);
  // mehrere -> varias

  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* v_zwei = neuen_knoten_variable($3);
  knoten_as* v_drei = neuen_knoten_variable($5);
  knoten_as* multiplikation = neuen_knoten_ausdruck(AUSDRUCK, "*", v_zwei, v_drei);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, multiplikation);
} |
VARIABLE GLEICH VARIABLE DIVISION VARIABLE ZEILENENDE {
  

  existieren_kontatieren($1);
  existieren_kontatieren($3);
  existieren_kontatieren($5);
  typen_vergleichen($1, $3);
  typen_vergleichen($1, $5);
  // mehrere_variables_vergleichen($1, $3, $5);
  // mehrere -> varias

  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* v_zwei = neuen_knoten_variable($3);
  knoten_as* v_drei = neuen_knoten_variable($5);
  knoten_as* division = neuen_knoten_ausdruck(AUSDRUCK, "/", v_zwei, v_drei);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, division);
} |
VARIABLE GLEICH ZEICHEN ZEILENENDE {
  

  existieren_kontatieren($1);
  zeichen_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* knoten_zeichen = neuen_knoten_zeichen($3);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, knoten_zeichen);
} |
VARIABLE GLEICH STRING ZEILENENDE {
  

  existieren_kontatieren($1);
  string_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);
  knoten_as* knoten_string = neuen_knoten_string($3);

  $$ = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, knoten_string);
} |
VARIABLE GLEICH BOOLEAN ZEILENENDE {
  

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
  

  existieren_kontatieren($1);
  gleitkomma_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);

  $$ = neuen_knoten_ausdruck(GLEITKOMMA_AUSDRUCK,"+",variable_blatt,$3);
} |
gleitkomma_ausdruck SUMME gleitkomma_ausdruck {

  $$ = neuen_knoten_ausdruck(GLEITKOMMA_AUSDRUCK,"+",$1,$3);
} |
gleitkomma_begriff  {
  
  $$ = $1;
}

gleitkomma_begriff:
GLEITKOMMA {
  
  $$ = neuen_knoten_gleitkomma($1);
}

//---------------------------

ganzzahl_ausdruck:
VARIABLE SUMME ganzzahl_begriff {
  

  existieren_kontatieren($1);
  ganzzahl_kontatieren($1);
  knoten_as* variable_blatt = neuen_knoten_variable($1);

  $$ = neuen_knoten_ausdruck(GANZZAHL_AUSDRUCK,"+",variable_blatt,$3);
} |
ganzzahl_ausdruck SUMME ganzzahl_begriff {
  
  $$ = neuen_knoten_ausdruck(GANZZAHL_AUSDRUCK,"+",$1,$3);
} |
ganzzahl_begriff  {
  
  $$ = $1;
}

ganzzahl_begriff:
GANZZAHL {
  
  $$ = neuen_knoten_ganzzahl($1);
}

wenn_urteil:
WENN KLAMMER_OFFEN bedingung KLAMMER_SCHLIESSEN SCHLUOFFEN korper SCHLUSCHLIESSEN {
  
  knoten_as* wenn_typ = neuen_knoten_ausdruck(39,"",0,0);
  $$ = neuen_knoten_wenn($3,wenn_typ,$6);
} |
WENN KLAMMER_OFFEN bedingung KLAMMER_SCHLIESSEN SCHLUOFFEN korper SCHLUSCHLIESSEN SONNST SCHLUOFFEN korper SCHLUSCHLIESSEN {
  knoten_as* wenn_typ = neuen_knoten_ausdruck(39,"",0,0);
  // nodo tipo_else = nuevo nodo 40 "" 0 0
  // nodo sonnst medio -> tipo_else, izq -> $6 (korper verdadero), der -> $10 (korper falso) 
  // $$ = neuen_knoten_wenn($3,wenn_typ,nodo_sonnst);
  $$ = neuen_knoten_wenn($3,wenn_typ,$6);
}

wahrend_urteil:
WAHREND KLAMMER_OFFEN bedingung KLAMMER_SCHLIESSEN SCHLUOFFEN korper SCHLUSCHLIESSEN {
  
  $$ = neuen_knoten_wahrend($3,$6);
}

fur_urteil:
FUR KLAMMER_OFFEN fur_ausdruck KLAMMER_SCHLIESSEN SCHLUOFFEN korper SCHLUSCHLIESSEN {
  
  $$ = neuen_knoten_fur($3,$6);
}

fur_ausdruck:
DEFGANZZAHL VARIABLE ZEILENENDE VARIABLE GLEICH GANZZAHL ZEILENENDE VARIABLE KLEINER GANZZAHL ZEILENENDE VARIABLE GLEICH VARIABLE SUMME GANZZAHL ZEILENENDE {

  
  if (!existieren($2)) {
    hinzufugen($1, $2);
  } else{
    yyerror("Variable existieren.");
  }

  
  existieren_kontatieren($4);
  ganzzahl_kontatieren($4);
  knoten_as* variable_blatt = neuen_knoten_variable($4);
  knoten_as* ganzzahl_blatt = neuen_knoten_ganzzahl($6);
  knoten_as* ganzzahl_ausdruck = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, ganzzahl_blatt);

  
  existieren_kontatieren($8);
  ganzzahl_kontatieren($8);
  knoten_as* variable_bedingung = neuen_knoten_variable($8);
  knoten_as* ganzzahl_bedingung = neuen_knoten_ganzzahl($10);
  knoten_as* bedingung = neuen_knoten_ausdruck(BEDINGUNG,"<",variable_bedingung,ganzzahl_bedingung);

  
  existieren_kontatieren($12);
  ganzzahl_kontatieren($12);
  existieren_kontatieren($14);
  ganzzahl_kontatieren($14);
  knoten_as* variable_blatt_2 = neuen_knoten_variable($14);
  knoten_as* ganzzahl_blatt_2 = neuen_knoten_ganzzahl($16);
  knoten_as* summe_ausdruck = neuen_knoten_ausdruck(GANZZAHL_AUSDRUCK ,"+" , variable_blatt_2, ganzzahl_blatt_2);

  $$ = neuen_knoten_fur_ausdruck(ganzzahl_ausdruck, bedingung, summe_ausdruck);
} |
DEFGANZZAHL VARIABLE ZEILENENDE VARIABLE GLEICH GANZZAHL ZEILENENDE VARIABLE GROSSER GANZZAHL ZEILENENDE VARIABLE GLEICH VARIABLE SUBSTRAKTION GANZZAHL ZEILENENDE {
  
  if (!existieren($2)) {
    hinzufugen($1, $2);
  } else{
    yyerror("Variable existieren.");
  }

  
  existieren_kontatieren($4);
  ganzzahl_kontatieren($4);
  knoten_as* variable_blatt = neuen_knoten_variable($4);
  knoten_as* ganzzahl_blatt = neuen_knoten_ganzzahl($6);
  knoten_as* ganzzahl_ausdruck = neuen_knoten_ausdruck(AUFGABE, "=", variable_blatt, ganzzahl_blatt);

  
  existieren_kontatieren($8);
  knoten_as* variable_bedingung = neuen_knoten_variable($8);
  knoten_as* ganzzahl_bedingung = neuen_knoten_ganzzahl($16);
  knoten_as* bedingung = neuen_knoten_ausdruck(BEDINGUNG,">",variable_bedingung,ganzzahl_bedingung);

  
  existieren_kontatieren($12);
  ganzzahl_kontatieren($12);
  existieren_kontatieren($14);
  ganzzahl_kontatieren($14);
  knoten_as* variable_blatt_2 = neuen_knoten_variable($14);
  knoten_as* ganzzahl_blatt_2 = neuen_knoten_ganzzahl($16);
  knoten_as* substraktion_ausdruck = neuen_knoten_ausdruck(GANZZAHL_AUSDRUCK ,"-" , variable_blatt_2, ganzzahl_blatt_2);

  $$ = neuen_knoten_fur_ausdruck(ganzzahl_ausdruck, bedingung, substraktion_ausdruck);
}
/*
|
DEFGANZZAHL VARIABLE ZEILENENDE VARIABLE GLEICH ganzzahl ZEILENENDE VARIABLE KLEINER_GLEICH ganzzahl ZEILENENDE VARIABLE GLEICH VARIABLE SUMME ganzzahl ZEILENENDE {

} |
DEFGANZZAHL VARIABLE ZEILENENDE VARIABLE GLEICH ganzzahl ZEILENENDE VARIABLE GROSSER_GLEICH ganzzahl ZEILENENDE VARIABLE GLEICH VARIABLE SUBSTRAKTION ganzzahl ZEILENENDE {

}
**/

ausdruck:
ganzzahl_ausdruck {
  $$ = $1;
} |
gleitkomma_ausdruck {
  $$ = $1;
} |
gemischte_ausdruck {
  $$ = $1;
}

bedingung:
bedingung UND bedingung {
  
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"&&",$1,$3);
} |
bedingung ODER bedingung {
  
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"||",$1,$3);
} |
bedingung UND VARIABLE {
  
  existieren_kontatieren($3);
  boolean_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"&&",$1,variable);
} |
bedingung ODER VARIABLE {
  
  existieren_kontatieren($3);
  boolean_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"||",$1,variable);
} |
VARIABLE UND bedingung {
  
  existieren_kontatieren($1);
  boolean_kontatieren($1);
  knoten_as* variable = neuen_knoten_variable($1);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"&&",variable,$3);
} |
VARIABLE ODER bedingung {
  
  existieren_kontatieren($1);
  boolean_kontatieren($1);
  knoten_as* variable = neuen_knoten_variable($1);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"||",variable,$3);
} |
ausdruck UNGLEICH ausdruck {
  
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"!=",$1,$3);
} |
ausdruck GLEICH_GLEICH ausdruck {
  
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"==",$1,$3);
} |
ausdruck GROSSER ausdruck {
  
  $$ = neuen_knoten_ausdruck(BEDINGUNG,">",$1,$3);
} |
ausdruck KLEINER ausdruck {
  
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"<",$1,$3);
} |
ausdruck GROSSER_GLEICH ausdruck {
  
  $$ = neuen_knoten_ausdruck(BEDINGUNG,">=",$1,$3);
} |
ausdruck KLEINER_GLEICH ausdruck {
  
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"<=",$1,$3);
} |
ausdruck UNGLEICH VARIABLE {
  
  existieren_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"!=",$1,variable);
} |
ausdruck GLEICH_GLEICH VARIABLE {
  
  existieren_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"==",$1,variable);
} |
ausdruck GROSSER VARIABLE {
  
  existieren_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,">",$1,variable);
} |
ausdruck KLEINER VARIABLE {
  
  existieren_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"<",$1,variable);
} |
ausdruck GROSSER_GLEICH VARIABLE {
  
  existieren_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,">=",$1,variable);
} |
ausdruck KLEINER_GLEICH VARIABLE {
  
  existieren_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"<",$1,variable);
} |
VARIABLE UNGLEICH ausdruck {
  
  existieren_kontatieren($1);
  knoten_as* variable = neuen_knoten_variable($1);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"!=",variable,$3);
} |
VARIABLE GLEICH_GLEICH ausdruck {
  
  existieren_kontatieren($1);
  knoten_as* variable = neuen_knoten_variable($1);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"==",variable,$3);
} |
VARIABLE GROSSER ausdruck {
  
  existieren_kontatieren($1);
  knoten_as* variable = neuen_knoten_variable($1);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,">",variable,$3);
} |
VARIABLE KLEINER ausdruck {
  
  existieren_kontatieren($1);
  knoten_as* variable = neuen_knoten_variable($1);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"<",variable,$3);
} |
VARIABLE GROSSER_GLEICH ausdruck {
  
  existieren_kontatieren($1);
  knoten_as* variable = neuen_knoten_variable($1);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,">=",variable,$3);
} |
VARIABLE KLEINER_GLEICH ausdruck {
  
  existieren_kontatieren($1);
  knoten_as* variable = neuen_knoten_variable($1);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"<=",variable,$3);
} |
VARIABLE UND VARIABLE {
  
  existieren_kontatieren($1);
  existieren_kontatieren($3);
  boolean_kontatieren($1);
  boolean_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($1);
  knoten_as* v_zwei = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"&&",variable,v_zwei);
} |
VARIABLE ODER VARIABLE {
  
  existieren_kontatieren($1);
  existieren_kontatieren($3);
  boolean_kontatieren($1);
  boolean_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($1);
  knoten_as* v_zwei = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"||",variable,v_zwei);
} |
VARIABLE UNGLEICH VARIABLE {
  
  existieren_kontatieren($1);
  existieren_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($1);
  knoten_as* v_zwei = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"!=",variable,v_zwei);
} |
VARIABLE GLEICH_GLEICH VARIABLE {
  
  existieren_kontatieren($1);
  existieren_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($1);
  knoten_as* v_zwei = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"==",variable,v_zwei);
} |
VARIABLE GROSSER VARIABLE {
  
  existieren_kontatieren($1);
  existieren_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($1);
  knoten_as* v_zwei = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,">",variable,v_zwei);
} |
VARIABLE KLEINER VARIABLE {
  
  existieren_kontatieren($1);
  existieren_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($1);
  knoten_as* v_zwei = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"<",variable,v_zwei);
} |
VARIABLE GROSSER_GLEICH VARIABLE {
  
  existieren_kontatieren($1);
  existieren_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($1);
  knoten_as* v_zwei = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,">=",variable,v_zwei);
} |
VARIABLE KLEINER_GLEICH VARIABLE {
  
  existieren_kontatieren($1);
  existieren_kontatieren($3);
  knoten_as* variable = neuen_knoten_variable($1);
  knoten_as* v_zwei = neuen_knoten_variable($3);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"<=",variable,v_zwei);
} |
NICHT VARIABLE {
  
  existieren_kontatieren($2);
  boolean_kontatieren($2);
  knoten_as* variable = neuen_knoten_variable($2);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"!",0,variable);
} |
VARIABLE {
  
  existieren_kontatieren($1);
  boolean_kontatieren($1);
  knoten_as* variable = neuen_knoten_variable($1);
  $$ = neuen_knoten_ausdruck(BEDINGUNG,"",0,variable);
} |
BOOLEAN {
  
  $$ = neuen_knoten_boolean($1);
}

;

%%

int main () {
  yyparse ();
  return 0;
}
