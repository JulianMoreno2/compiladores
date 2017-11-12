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
#define DEF_GANZZAHL 34
#define DEF_GLEITKOMMA 35
#define DEF_ZEICHEN 36
#define DEF_STRING 37
#define DEF_BOOLEAN 38
#define WENN_AUSDRUCK 39
#define SONST_AUSDRUCK 40
#define SONST_URTEIL 41
#define WAHREND_AUSDRUCK 42

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

struct knoten_as * intermediate_code = NULL;
int flag = 0;

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

struct knoten_as* neuen_knoten_def(int knotenTyp, char* variable)
{
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->knotenTyp = knotenTyp;
    neuenKnoten->variable = (char*) malloc(sizeof(char) * 50);
    strcpy(neuenKnoten->variable, variable);
    neuenKnoten->mittel = 0;
    neuenKnoten->rechte = 0;
    neuenKnoten->linke = 0;
    return neuenKnoten;   
};

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
struct knoten_as* neuen_knoten_sonst(struct knoten_as* wurzel,struct knoten_as* linke, struct knoten_as* mittel, struct knoten_as* rechte)
{
    struct knoten_as* neuenKnoten = NULL;
    if (wurzel == NULL){
        neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
        neuenKnoten->operatore = 0;
        neuenKnoten->knotenTyp = SONST_URTEIL;
        neuenKnoten->linke = linke;
        neuenKnoten->mittel = mittel;
        neuenKnoten->rechte = rechte;
        wurzel = neuenKnoten;
        return neuenKnoten;

    }
    if (wurzel->rechte==NULL){
        wurzel->rechte = neuen_knoten_sonst(wurzel->rechte,linke, mittel, rechte);
    }
    return wurzel;

}

struct knoten_as* neuen_knoten_wahrend(struct knoten_as* bedingung, struct knoten_as* mittel, struct knoten_as* rechte)
{
    struct knoten_as* neuenKnoten = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    neuenKnoten->operatore = 0;
    neuenKnoten->knotenTyp = WAHREND_URTEIL;
    neuenKnoten->linke = bedingung;
    neuenKnoten->mittel = mittel;
    neuenKnoten->rechte = rechte;
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

void in_orden(struct knoten_as* wurzel){
    if (wurzel!=NULL){
        in_orden(wurzel->mittel);
        in_orden(wurzel->linke);
        in_orden(wurzel->rechte);
        
        
        if (wurzel->operatore!=NULL){
            intermediate_code->operatore = wurzel->operatore;
            if ((strcmp (intermediate_code->operatore, "="))==0){
                printf("ASIG ");
            }else if ((strcmp (intermediate_code->operatore, "+"))==0){
                printf("ADD ");
                flag++;
            }else if ((strcmp (intermediate_code->operatore, "-"))==0){
                printf("SUB ");
                flag++;
            }else if ((strcmp (intermediate_code->operatore, "*"))==0){
                printf("MUL ");
                flag++;
            }else if ((strcmp (intermediate_code->operatore, "/"))==0){
                printf("DIV ");
                flag++;
            }
            
            if(flag > 2) {
                flag = 0;
                printf("\n");
            } else if(flag == 0) {
                printf("\n");
            }            
        }

        if(wurzel->knotenTyp==WENN_AUSDRUCK){
            printf("WENN ");
        }

        if(wurzel->knotenTyp==SONST_AUSDRUCK){
            printf("SONST \n");
        }

        if(wurzel->knotenTyp==WAHREND_AUSDRUCK){
            printf("WAHREND_AUSDRUCK ");
        }

        if (wurzel->variable!=NULL){
            printf("%s ",wurzel->variable);
            intermediate_code->variable = wurzel->variable;
        } 

        if (wurzel->knotenTyp==DEF_GANZZAHL){
            printf("DEF_GANZZAHL \n");
            intermediate_code->knotenTyp = wurzel->knotenTyp;
        }

        if (wurzel->knotenTyp==DEF_GLEITKOMMA){
            printf("DEF_GLEITKOMMA \n");
            intermediate_code->knotenTyp = wurzel->knotenTyp;
        }

        if (wurzel->knotenTyp==DEF_ZEICHEN){
            printf("DEF_ZEICHEN \n");
            intermediate_code->knotenTyp = wurzel->knotenTyp;
        }

        if (wurzel->knotenTyp==DEF_STRING){
            printf("DEF_STRING \n");
            intermediate_code->knotenTyp = wurzel->knotenTyp;
        }

        if (wurzel->knotenTyp==DEF_BOOLEAN){
            printf("DEF_BOOLEAN \n");
            intermediate_code->knotenTyp = wurzel->knotenTyp;
        }

        if (wurzel->knotenTyp==GANZZAHL_BLATT){
            printf("%d ",wurzel->ganzzahlWert);
            intermediate_code->ganzzahlWert = wurzel->ganzzahlWert;
        }
        if (wurzel->knotenTyp==GLEITKOMMA_BLATT){
            printf("%f ",wurzel->gleitkommaWert);
            intermediate_code->gleitkommaWert = wurzel->gleitkommaWert;
        }
        if (wurzel->knotenTyp==ZEICHEN_BLATT){
            printf("%s ",wurzel->zeichenWert);
            intermediate_code->zeichenWert = wurzel->zeichenWert;
        }
        if (wurzel->knotenTyp==STRING_BLATT){
            printf("%s ",wurzel->stringWert);
            intermediate_code->stringWert = wurzel->stringWert;
        }
        if (wurzel->knotenTyp==BOOLEAN_BLATT){
            printf("%s ",wurzel->booleanWert);
            intermediate_code->booleanWert = wurzel->booleanWert;
        }
        //printf("knotenTyp %d\n",wurzel->knotenTyp);
        intermediate_code->knotenTyp = wurzel->knotenTyp;

    }
}

void generate_intermediate_code(struct knoten_as* wurzel) {
    printf("Generating intermediate code !!!!!\n");
    printf("-----durchlaufen wurzel-----\n");
    intermediate_code = (struct knoten_as*) malloc(sizeof(struct knoten_as));
    in_orden(wurzel);
}

;

#endif /* BAUM_C */
