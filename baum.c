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
#define AUFGABE 4 //asignacion
#define URTEIL 5 // sentencia
#define SUMME_GEMISCHTE 6 // mixto = gemischte?
#define FAKTOR_GANZEN 7 // ganzen = entero?
#define BEGRIFF_GANZEN 8 // begriff = termino?
#define AUSDRUCK_GANZEN 9
#define FAKTOR_GLEITKOMMA 10
#define BEGRIFF_GLEITKOMMA 11
#define AUSDRUCK_GLEITKOMMA 12 // ausdruck = expresion?
#define AUSDRUCK 13
#define BLATT_GANZEN 14
#define BLATT_GLEITKOMMA 15

typedef struct knoten_as
{
    char* operator;
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
struct knoten_as* neuen_knoten_ausdruck (int knotenTyp, char* operator, struct knoten_as* linke, struct knoten_as* rechte) {
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->operator = (char*) malloc(sizeof(char) * 2);
    strcpy(neuenKnoten->operator, operator);
    neuenKnoten->knotenTyp = knotenTyp;
    neuenKnoten->mittel = 0;
    neuenKnoten->rechte = rechte;
    neuenKnoten->linke = linke;
    return neuenKnoten;
}

struct knoten_as* neuen_knoten_ganzen (int wert) {
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->knotenTyp = BLATT_GANZEN;
    neuenKnoten->ganzzahlWert = wert;
    neuenKnoten->rechte = 0;
    neuenKnoten->linke = 0;
    neuenKnoten->mittel = 0;
    return neuenKnoten;
}

struct knoten_as* neuen_knoten_gleitkomma (float wert) {
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->knotenTyp = BLATT_GLEITKOMMA;
    neuenKnoten->gleitkommaWert = wert;
    neuenKnoten->rechte = 0;
    neuenKnoten->linke = 0;
    return neuenKnoten;
}

#endif /* BAUM_C */
