%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "airport.tab.h"

extern YYSTYPE yylval;
%}

%option noyywrap
%option yylineno

%%
"<departures>"            { return DEPARTURES; }

[A-Z]{2}[0-9]{1,4}        { 
    yylval.str = strdup(yytext);
    return FLIGHT_NUMBER; 
}

([0]?[0-9]|1[0-2]):[0-5][0-9]([aA]\.[mM]\.|[pP]\.[mM]\.)    { 
    yylval.str = strdup(yytext);
    return TIME; 
}

([0-1][0-9]|2[0-3]):[0-5][0-9]                              { 
    yylval.str = strdup(yytext);
    return TIME; 
}

\[([A-Za-z]+([ ]+[A-Za-z]+)*)\]                            { 
    yylval.str = strdup(yytext);
    return AIRPORT; 
}

"cargo"                  { return CARGO; }

"freight"                { return FREIGHT; }

[ \t\r]+                 { /* Ignore whitespace */ }

\n                       { /* Line counting is done automatically by yylineno */ }

.                        { fprintf(stderr, "Error on line %d: unexpected character '%s'\n", yylineno, yytext); }
%%