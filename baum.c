#ifndef BAUM_C
#define BAUM_C

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "tabelle.c"

#define MAIN 1
#define KORPER 2 //cuerpo
#define AUSSAGE 3 // declaracion
#define AUFGABE 4 // asignacion
#define URTEIL 5 // sentencia
#define GEMISCHTE_SUMME 6 // mixto = gemischte?
#define GANZZAHL_FAKTOR 7 // ganzzahl = entero?
#define GANZZAHL_BEGRIFF 8 // begriff = termino?
#define GANZZAHL_AUSDRUCK 9
#define GLEITKOMMA_FAKTOR 10
#define GLEITKOMMA_BEGRIFF 11
#define GLEITKOMMA_AUSDRUCK 12 // ausdruck = expresion?
#define AUSDRUCK 13
#define GANZZAHL_BLATT 14
#define GLEITKOMMA_BLATT 15
#define VARIABLE_BLATT 15

typedef struct knoten_as
{
    char* operatore;
    char* variable;
    int knotenTyp;
    int ganzzahlWert;
    float gleitkommaWert;
    char* characterWert;
    char* stringWert;
    char* booleanWert;
    struct knoten_as* linke;
    struct knoten_as* mittel;
    struct knoten_as* rechte;
} knoten_as;

//Nuevo nodo expresion
struct knoten_as* neuen_knoten_ausdruck (int knotenTyp, char* operatore, struct knoten_as* linke, struct knoten_as* rechte) {
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->operatore = (char*) malloc(sizeof(char) * 2);
    strcpy(neuenKnoten->operatore, operatore);
    neuenKnoten->knotenTyp = knotenTyp;
    neuenKnoten->mittel = 0;
    neuenKnoten->rechte = rechte;
    neuenKnoten->linke = linke;
    return neuenKnoten;
}

struct knoten_as* neuen_knoten_ganzzahl (int wert) {
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->knotenTyp = GANZZAHL_BLATT;
    neuenKnoten->ganzzahlWert = wert;
    neuenKnoten->rechte = 0;
    neuenKnoten->linke = 0;
    neuenKnoten->mittel = 0;
    return neuenKnoten;
}

struct knoten_as* neuen_knoten_gleitkomma (float wert) {
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->knotenTyp = GLEITKOMMA_BLATT;
    neuenKnoten->gleitkommaWert = wert;
    neuenKnoten->rechte = 0;
    neuenKnoten->linke = 0;
    neuenKnoten->mittel = 0;
    return neuenKnoten;
}

struct knoten_as* neuen_knoten_variable(char* variable)
{
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->knotenTyp = VARIABLE_BLATT;
    neuenKnoten->variable = (char*) malloc(sizeof(char) * 50);
    strcpy(neuenKnoten->variable, variable);
    neuenKnoten->mittel = 0;
    neuenKnoten->rechte = 0;
    neuenKnoten->linke = 0;
    return neuenKnoten;
}

#endif /* BAUM_C */
