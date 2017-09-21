%option noyywrap
%option yylineno


%{
#include "syntaktische.tab.h"
#include <string.h>
%}

/*Definition von typen*/

Int          -?[0-9]{1,}
Schwimmende  -?[0-9]+[.]{1}[0-9]+
Charakter    ["]{1}.{1}["]{1}
String       ["]{1}.{1,255}["]{1}
Variable     [A-Za-z]{1,50}

ignora       " "|\t|\n
Boolean      "richtig"|"falsch"

/*Definition der reservierten worter*/

int            "int"
schwimmende    "schwimmende"
charakter      "charakter"
string         "string"
boolean        "boolean"

%%
";"            { return ZEILENENDE; }
{ignora}+      {}
{int}          {strcpy (yylval.art, yytext);return  DEFINTEGER;}
{schwimmende}  {strcpy (yylval.art, yytext);return  DEFSCHWIMMENDE;}
{charakter}    {strcpy (yylval.art, yytext);return  DEFCHARAKTER;}
{string}       {strcpy (yylval.art, yytext);return  DEFSTRING;}
{boolean}      {strcpy (yylval.art, yytext);return  DEFBOOLEAN;}

"="            {return GLEICH;}
"!="           {return UNGLEICH;}
","            {return KOMA;}
"=="           {return GLEICH_GLEICH;}
"."            {return PUNKT;}
">="           {return GROSSER_GLEICH;}
"<="           {return KLEINER_GLEICH;}
"("            {return KLAMMER_OFFEN;}
")"            {return KLAMMER_SCHLIESSEN;}
">"            {return GROSSER;}
"<"            {return KLEINER;}
"{"            {return SCHLUOFFEN;}
"}"            {return SCHLUSCHLIESSEN;}
"+"            {return SUMME;}
"-"            {return SUBSTRAKTION;}
"*"            {return MULTIPLIKATION;}
"/"            {return DIVISION;}
"&"            {return UND;}
"||"           {return ODER;}
"!"            {return NICHT;}

"main"         {return MAIN;}
"wenn"         {return WENN;}
"sonnst"       {return SONNST;}
"wahrend"      {return WAHREND;}


{Int}          {yylval.nummer = atoi(yytext);return INTEGER;}
{Schwimmende}  {yylval.schwimmende = atof(yytext);return SCHWIMMENDE;}
{Boolean}      {strcpy (yylval.variable, yytext);return BOOLEAN;}
{Variable}     {strcpy (yylval.variable, yytext); return VARIABLE;}
{Charakter}    {strcpy (yylval.variable, yytext);return CHARAKTER;}
{String}       {strcpy (yylval.variable, yytext);return STRING;}


.{256,}        {printf("Lexikalische fehler %d \n",yylineno);}
%%
