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
"!="       {return VERSCHIEDENE;}
","        {return KOMA;}
"=="       {return VERGLEICH;}
"."        {}
">="       {return GROBERGLEICH;}
"<="       {return WENIGERGLEICH;}
"("        {return KLAM_OFFEN;}
")"        {return KLAM_SCHLIESSEN;}
">"        {return GROBER;}
"<"        {return WENIGER;}
"{"        {return SCHLUOFFEN;}
"}"        {return SCHLUSCHLIESSEN;}
"+"        {return BESUMME;}
"-"        {return BEMINDES;}
"*"        {return BEMULT;}
"/"        {return BETEI;}
"&"        {return UND;}
"||"       {return ODER;}
"!"        {return NICHT;}

"haupt"    {return HAUPT;}
"wenn"     {return WENN;}
"anderes"  {return ANDERES;}
"wahrend"  {return WAHREND;}


{Int}      {yylval.nummer = atoi(yytext);return INTEGER;}
{Float}    {yylval.float = atof(yytext);return FLOAT;}
{Boolean}  {strcpy (yylval.variable, yytext);return BOOLEAN;}
{Variable} {strcpy (yylval.variable, yytext); return VARIABLE;}
{Char}     {strcpy (yylval.variable, yytext);return CHARACTER;}
{String}   {strcpy (yylval.variable, yytext);return STRING;}


.{256,}    {printf("Lexikalische fehler %d \n",yylineno);} 
%%

