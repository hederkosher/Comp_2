%option noyywrap
%{
#include "airport.h"
#include <stdio.h>
#include <string.h>

int line_num = 1;
%}

%%
"<departures>"            { return T_DEPARTURES; }

[A-Z]{2}[0-9]{1,4}        { return T_FLIGHT_NUMBER; }

([0]?[0-9]|1[0-2]):[0-5][0-9]([aA]\.[mM]\.|[pP]\.[mM]\.)    { return T_TIME; }

([0-1][0-9]|2[0-3]):[0-5][0-9]                              { return T_TIME; }

\[([A-Za-z]+([ ]+[A-Za-z]+)*)\]                            { return T_AIRPORT; }

"cargo"                  { return T_CARGO; }

"freight"                { return T_FREIGHT; }

[ \t\r]+                 { /* ignore whitespace */ }

\n                       { line_num++; }

.                        { fprintf(stderr, "Error at line %d: unexpected character '%s'\n", line_num, yytext); }
%%