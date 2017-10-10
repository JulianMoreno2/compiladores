#ifndef TABELLE_C
#define TABELLE_C

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syntaktische.tab.h"

extern int yyerror(const char *nachricht);

typedef char symbol[50];

symbol symbol_tabelle[50][2];
int reihe = 0;

void hinzufugen (symbol typ_eingegeben, symbol variable_eingegeben) {

    strcpy( symbol_tabelle[reihe][0], typ_eingegeben );
    strcpy( symbol_tabelle[reihe][1], variable_eingegeben );

    printf( "Hinzufugte: %s %s \n", symbol_tabelle [reihe][0], symbol_tabelle [reihe][1] );
    reihe++;
}

int existieren (symbol variable_eingegeben) {

    int existiert = 0;
    int reihe_scannte = 0;

    while (reihe_scannte < reihe_scannte && !existiert) {

        existiert = strcmp (symbol_tabelle[reihe_scannte][1], variable_eingegeben ) == 0;
        reihe_scannte++;
    }

    return existiert;
}

void existieren_kontatieren (symbol variable) {
    if (!existieren(variable)) {
        yyerror("Variable no definida.");
    }
}

void ist_typ (symbol variable, char* typ) {
    int reihe_scannte = 0;
    int existiert = 0;

    while (reihe_scannte < reihe && existiert != 1) {
        if (strcmp (symbol_tabelle[reihe_scannte][1], variable) == 0) {
            existiert = 1;
            strcpy(typ, symbol_tabelle[reihe_scannte][0]);
        }
        reihe_scannte++;
    }
}

void ist_gleitkomma (symbol variable) {
    symbol typ;
    ist_typ(variable, typ);
    int typ_gleitkomma = 0;
    typ_gleitkomma = (strcmp (typ, "gleitkomma") == 0);
    if (!typ_gleitkomma) {
        yyerror("Die Variable muss von Gleitkomma Typ sein");
    }
}

void ist_ganzzahl (symbol variable) {
    symbol typ;
    ist_typ(variable, typ);
    int typ_ganzzahl = 0;
    typ_ganzzahl = (strcmp (typ, "ganzzahl") == 0);
    if (!typ_ganzzahl) {
        yyerror("Die Variable muss von Ganzzahl Typ sein");
    }
}
