%option noyywrap
%option yylineno

%{
#include "syntaktische.tab.h"
#include <string.h>
%}

/*Definition von typen*/

Ganzzahl      -?[0-9]{1,}
Gleitkomma    -?[0-9]+[.]{1}[0-9]+
Zeichen       ["]{1}.{1}["]{1}
String        ["]{1}.{1,255}["]{1}
Variable      [A-Za-z]{1,50}

ignora        " "|\t|\n
Boolean       "richtig"|"falsch"

/*Definition der reservierten worter*/

ganzzahl      "ganzzahl"
gleitkomma    "gleitkomma"
zeichen       "zeichen"
string        "string"
boolean       "boolean"

%%
";"           { return ZEILENENDE; }
{ignora}+     {}
{ganzzahl}    {strcpy (yylval.typ, yytext);return  DEFGANZZAHL;}
{gleitkomma}  {strcpy (yylval.typ, yytext);return  DEFGLEITKOMMA;}
{zeichen}     {strcpy (yylval.typ, yytext);return  DEFZEICHEN;}
{string}      {strcpy (yylval.typ, yytext);return  DEFSTRING;}
{boolean}     {strcpy (yylval.typ, yytext);return  DEFBOOLEAN;}

"="           {return GLEICH;}
"!="          {return UNGLEICH;}
","           {return KOMA;}
"=="          {return GLEICH_GLEICH;}
"."           {return PUNKT;}
">="          {return GROSSER_GLEICH;}
"<="          {return KLEINER_GLEICH;}
"("           {return KLAMMER_OFFEN;}
")"           {return KLAMMER_SCHLIESSEN;}
">"           {return GROSSER;}
"<"           {return KLEINER;}
"{"           {return SCHLUOFFEN;}
"}"           {return SCHLUSCHLIESSEN;}
"+"           {return SUMME;}
"-"           {return SUBSTRAKTION;}
"*"           {return MULTIPLIKATION;}
"/"           {return DIVISION;}
"&&"          {return UND;}
"||"          {return ODER;}
"!"           {return NICHT;}

"generate"    {return GENERATE;}
"main"        {return MAIN;}
"wenn"        {return WENN;}
"sonnst"      {return SONNST;}
"wahrend"     {return WAHREND;}
"fur"         {return FUR;}

{Ganzzahl}    {yylval.ganzzahl = atoi(yytext);return GANZZAHL;}
{Gleitkomma}  {yylval.gleitkomma = atof(yytext);return GLEITKOMMA;}
{Boolean}     {strcpy (yylval.variable, yytext);return BOOLEAN;}
{Variable}    {strcpy (yylval.variable, yytext); return VARIABLE;}
{Zeichen}     {strcpy (yylval.variable, yytext);return ZEICHEN;}
{String}      {strcpy (yylval.variable, yytext);return STRING;}


.{256,}       {printf("Lexikalische fehler %d \n",yylineno);}
%%
