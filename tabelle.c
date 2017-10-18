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

    while (reihe_scannte < reihe && existiert != 1) {
        existiert = strcmp (symbol_tabelle[reihe_scannte][1], variable_eingegeben) == 0;
        reihe_scannte++;
    }

    return existiert;
}

void existieren_kontatieren (symbol variable) {
    printf("existieren_kontatieren\n");
    if (!existieren(variable)) {
        yyerror("Variable nicht definiten.\n");
    }
}

void typ_des (symbol variable_eingegeben, char*  typ) {
    int existiert = 0;
    int reihe_scannte = 0;

    while (reihe_scannte < reihe && existiert != 1) {
        if (strcmp (symbol_tabelle[reihe_scannte][1], variable_eingegeben) == 0) {
            existiert = 1;
            strcpy(typ, symbol_tabelle[reihe_scannte][0]);
        }

        reihe_scannte++;
    }
}

int ist_gleitkomma (symbol variable) {
    symbol typ;
    typ_des(variable, typ);
    int ist = 0;
    if (strcmp(typ, "gleitkomma") == 0) {
        printf("ist_gleitkomma\n");
        ist = 1;
    }
    return ist;
}

int ist_ganzzahl (symbol variable) {
    symbol typ;
    typ_des(variable, typ);
    int ist = 0;
    if (strcmp(typ, "ganzzahl") == 0) {
        printf("ist_ganzzahl\n");
        ist = 1;
    }
    return ist;
}

int ist_zeichen (symbol variable) {
    symbol typ;
    typ_des(variable, typ);
    int ist = 0;
    if (strcmp(typ, "zeichen") == 0) {
        printf("ist_zeichen\n");
        ist = 1;
    }
    return ist;
}

int ist_string (symbol variable) {
    symbol typ;
    typ_des(variable, typ);
    int ist = 0;
    if (strcmp(typ, "string") == 0) {
        printf("ist_string\n");
        ist = 1;
    }
    return ist;
}

int ist_boolean (symbol variable) {
    symbol typ;
    typ_des(variable, typ);
    int ist = 0;
    if (strcmp(typ, "boolean") == 0) {
        printf("ist_boolean\n");
        ist = 1;
    }
    return ist;
}

void ganzzahl_kontatieren (symbol variable) {
    printf("ganzzahl_kontatieren\n");
    if (!ist_ganzzahl(variable)) {
        yyerror("Variable nicht ist ganzzahl.\n");
    }
}

void gleitkomma_kontatieren (symbol variable) {
    printf("gleitkomma_kontatieren\n");
    if (!ist_gleitkomma(variable)) {
        yyerror("Variable nicht ist gleitkomma.\n");
    }
}

void zeichen_kontatieren (symbol variable) {
    printf("zeichen_kontatieren\n");
    if (!ist_zeichen(variable)) {
        yyerror("Variable nicht ist zeichen.\n");
    }
}

void string_kontatieren (symbol variable) {
    printf("string_kontatieren\n");
    if (!ist_string(variable)) {
        yyerror("Variable nicht ist string.\n");
    }
}

void boolean_kontatieren (symbol variable) {
    printf("boolean_kontatieren\n");
    if (!ist_boolean(variable)) {
        yyerror("Variable nicht ist boolean.\n");
    }
}

int sind_ganzzahl (symbol variable_eingegeben_1, symbol variable_eingegeben_2) {
    int sind_ganzzahl = 0;
    symbol typ_1;
    symbol typ_2;

    typ_des(variable_eingegeben_1, typ_1);
    typ_des(variable_eingegeben_2, typ_2);

    if ((ist_ganzzahl(typ_1) == 1) && (ist_ganzzahl(typ_2) == 1)) {
        printf("sind_ganzzahl\n");
        sind_ganzzahl = 1;
    }

    return sind_ganzzahl;
}

int sind_vom_gleichen_typ (symbol variable_eingegeben_1, symbol variable_eingegeben_2) {
    int gleich_typ = 0;
    symbol typ_1, typ_2;

    typ_des(variable_eingegeben_1, typ_1);
    typ_des(variable_eingegeben_2, typ_2);

    if ( strcmp (typ_1, typ_2) == 0 ) {
        gleich_typ = 1;
    }

    if (ist_ganzzahl(variable_eingegeben_1) == 1 && ist_gleitkomma(variable_eingegeben_2) == 1) {
        gleich_typ = 1;
    }

    if (ist_ganzzahl(variable_eingegeben_2) == 1 && ist_gleitkomma(variable_eingegeben_1) == 1) {
        gleich_typ = 1;
    }

    if(gleich_typ == 1) {
        printf("sind_vom_gleichen_typ\n");
    }
    return gleich_typ;
}

void typen_vergleichen(symbol a, symbol b) {
    printf("typen_vergleichen\n");
    if (sind_vom_gleichen_typ(a, b) == 0) {
        yyerror("Inkompatible Typen");
    }
}

/**
void mehrere_variables_vergleichen (symbol a, symbol b ,symbol c){
    if (!sind_ganzzahl(a,b) || !sind_ganzzahl(b,c)) {
        yyerror("Esta operacion solo se puede aplicar a tipos de datos numericos.");
    } else if ((!sind_vom_gleichen_typ(a, b) || !sind_vom_gleichen_typ(b, c)) && !ist_gleitkomma(a)) {
        yyerror("La variable a la cual asignar debe ser del tipo float.");
    }
}
*/

#endif /* TABELLE_C */
