#ifndef AIRPORT_H
#define AIRPORT_H

enum token_t {
    T_DEPARTURES = 1,
    T_FLIGHT_NUMBER,
    T_TIME,
    T_AIRPORT,
    T_CARGO,
    T_FREIGHT
};

extern int yylex();
extern char* yytext;
extern int line_num;

#endif