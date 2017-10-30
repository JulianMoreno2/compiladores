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
#define GLEITKOMMA_AUSDRUCK 12 
#define ZEICHEN_FAKTOR 13
#define ZEICHEN_BEGRIFF 14
#define ZEICHEN_AUSDRUCK 15 
#define STRING_FAKTOR 16
#define STRING_BEGRIFF 17
#define STRING_AUSDRUCK 18
#define BOOLEAN_FAKTOR 19
#define BOOLEAN_BEGRIFF 20
#define BOOLEAN_AUSDRUCK 21
#define AUSDRUCK 22 // ausdruck = expresion?
#define GANZZAHL_BLATT 23
#define GLEITKOMMA_BLATT 24
#define VARIABLE_BLATT 25
#define ZEICHEN_BLATT 26
#define STRING_BLATT 27
#define BOOLEAN_BLATT 28
#define WENN_URTEIL 29
#define WAHREND_URTEIL 30
#define BEDINGUNG 31 // condicion?
#define FUR_URTEIL 32
#define FUR_AUSDRUCK 33

typedef struct knoten_as
{
    char* operatore;
    char* variable;
    int knotenTyp;
    int ganzzahlWert;
    float gleitkommaWert;
    char* zeichenWert;
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

struct knoten_as* neuen_knoten_zeichen (char* wert) {
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->knotenTyp = ZEICHEN_BLATT;
    neuenKnoten->zeichenWert = (char*) malloc(sizeof(char) * 50);
    strcpy(neuenKnoten->zeichenWert , wert);
    neuenKnoten->rechte = 0;
    neuenKnoten->linke = 0;
    neuenKnoten->mittel = 0;
    return neuenKnoten;
}

struct knoten_as* neuen_knoten_string (char* wert) {
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->knotenTyp = STRING_BLATT;
    neuenKnoten->stringWert = (char*) malloc(sizeof(char) * 50);
    strcpy(neuenKnoten->stringWert , wert);
    neuenKnoten->rechte = 0;
    neuenKnoten->linke = 0;
    neuenKnoten->mittel = 0;
    return neuenKnoten;
}

struct knoten_as* neuen_knoten_boolean (char* wert) {
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->knotenTyp = BOOLEAN_BLATT;
    neuenKnoten->booleanWert = (char*) malloc(sizeof(char) * 10);
    strcpy(neuenKnoten->booleanWert , wert);
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

struct knoten_as* neuen_knoten_wenn(struct knoten_as* bedingung, struct knoten_as* mittel, struct knoten_as* rechte)
{
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->operatore = 0;
    neuenKnoten->knotenTyp = WENN_URTEIL;
    neuenKnoten->linke = bedingung;
    neuenKnoten->mittel = mittel;
    neuenKnoten->rechte = rechte;
    return neuenKnoten;
}

struct knoten_as* neuen_knoten_wahrend(struct knoten_as* bedingung, struct knoten_as* korper)
{
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->operatore = 0;
    neuenKnoten->knotenTyp = WAHREND_URTEIL;
    neuenKnoten->linke = bedingung;
    neuenKnoten->mittel = 0;
    neuenKnoten->rechte = korper;
    return neuenKnoten;
}

struct knoten_as* neuen_knoten_fur(struct knoten_as* fur_asdruck, struct knoten_as* korper)
{
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->operatore = 0;
    neuenKnoten->knotenTyp = FUR_URTEIL;
    neuenKnoten->linke = fur_asdruck;
    neuenKnoten->mittel = 0;
    neuenKnoten->rechte = korper;
    return neuenKnoten;
}

struct knoten_as* neuen_knoten_fur_ausdruck(struct knoten_as* ganzzahl_ausdruck, struct knoten_as* bedingung, struct knoten_as* summe_ausdruck)
{
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->operatore = 0;
    neuenKnoten->knotenTyp = FUR_AUSDRUCK;
    neuenKnoten->linke = ganzzahl_ausdruck;
    neuenKnoten->mittel = bedingung;
    neuenKnoten->rechte = summe_ausdruck;
    return neuenKnoten;
}

void generate_intermediate_code(void) {
    printf("Generating intermediate code !!!!!\n");
}

;

#endif /* BAUM_C */
