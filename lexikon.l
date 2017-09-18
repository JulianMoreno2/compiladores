%option noyywrap
%option yylineno 


%{
#include "syntaktische.tab.h"
#include <string.h>
%}

/*Definition von typen*/

Int    -?[0-9]{1,}
Float  -?[0-9]+[.]{1}[0-9]+
Char   ["]{1}.{1}["]{1}
String ["]{1}.{1,255}["]{1}
Variable [A-Za-z]{1,50}

ignora " "|\t|\n 
Boolean "richtig"|"falsch"

/*Definition der reservierten worter*/

int     "int"
float   "float"
char    "char"
string  "string" 
boolean "boolean"

%%
";"        { return ZEILENENDE; }
{ignora}+  {}
{int}      {strcpy (yylval.art, yytext);return  DEFINTEGER;}
{float}    {strcpy (yylval.art, yytext);return  DEFFLOAT;}
{char}     {strcpy (yylval.art, yytext);return  DEFCHAR;}
{string}   {strcpy (yylval.art, yytext);return  DEFSTRING;}
{boolean}  {strcpy (yylval.art, yytext);return  DEFBOOLEAN;}

"="        {return GLEICH;}
"!="       {return UNGLEICH;}
","        {return KOMA;}
"=="       {return GLEICH_GLEICH;}
"."        {return PUNKT}
">="       {return GROSSER_GLEICH;}
"<="       {return KLEINER_GLEICH;}
"("        {return KLAMMER_OFFEN;}
")"        {return KLAMMER_SCHLIESSEN;}
">"        {return GROSSER;}
"<"        {return KLEINER;}
"{"        {return SCHLUOFFEN;}
"}"        {return SCHLUSCHLIESSEN;}
"+"        {return SUMME;}
"-"        {return SUBSTRAKTION;}
"*"        {return MULTIPLIKATION;}
"/"        {return DIVISION;}
"&"        {return UND;}
"||"       {return ODER;}
"!"        {return NICHT;}

"main"    {return MAIN;}
"wenn"     {return WENN;}
"sonnst"  {return SONNST;}
"wahrend"  {return WAHREND;}


{Int}      {yylval.nummer = atoi(yytext);return INTEGER;}
{Float}    {yylval.float = atof(yytext);return FLOAT;}
{Boolean}  {strcpy (yylval.variable, yytext);return BOOLEAN;}
{Variable} {strcpy (yylval.variable, yytext); return VARIABLE;}
{Char}     {strcpy (yylval.variable, yytext);return CHARACTER;}
{String}   {strcpy (yylval.variable, yytext);return STRING;}


.{256,}    {printf("Lexikalische fehler %d \n",yylineno);} 
%%

