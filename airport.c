#include <stdio.h>
#include <string.h>
#include "airport.h"
#include <stdlib.h> 

int token;
int before_noon = 0, after_noon = 0;

int is_before_noon(const char* time) {
    if (strstr(time, "a.m.") || strstr(time, "A.M.")) return 1;
    if (strstr(time, "p.m.") || strstr(time, "P.M.")) return 0;
    int hour = atoi(time);  // 24-hour format
    return hour < 12;
}

void advance() {
    token = yylex();
}

void parse_flight() {
    if (token != T_FLIGHT_NUMBER) return;
    char flight_num[64];
    strcpy(flight_num, yytext);

    advance();
    if (token != T_TIME) return;
    char time_str[32];
    strcpy(time_str, yytext);
    int is_morning = is_before_noon(time_str);

    advance();
    if (token != T_AIRPORT) return;

    advance();
    int is_cargo = 0;
    if (token == T_CARGO || token == T_FREIGHT) {
        is_cargo = 1;
        advance();
    }

    if (is_cargo)
        printf("%s\n", flight_num);

    if (is_morning) before_noon++;
    else after_noon++;
}

void parse_flights_list() {
    while (token == T_FLIGHT_NUMBER) {
        parse_flight();
    }
}

void parse() {
    advance();
    if (token == T_DEPARTURES) {
        advance();
        parse_flights_list();
    }

    printf("\nnumber of flights before noon: %d\n", before_noon);
    printf("number of flights after noon: %d\n", after_noon);
}

int main() {
    parse();
    return 0;
}