%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;

void yyerror(const char *s);

/* Counters and global variables */
int before_noon_count = 0;
int after_noon_count = 0;
char* cargo_flights[100]; /* Array for storing cargo flight numbers */
int cargo_flights_count = 0;

/* Function to check if the time is before noon */
int is_before_noon(char* time_str) {
    /* Check for a.m./p.m. format */
    if (strstr(time_str, "a.m.")) {
        return 1;
    } else if (strstr(time_str, "p.m.")) {
        return 0;
    }
    
    /* Check for 24-hour format */
    int hour, minute;
    sscanf(time_str, "%d:%d", &hour, &minute);
    
    if (hour >= 0 && hour < 12) {
        return 1;
    } else {
        return 0;
    }
}
%}

/* Semantic value types definition */
%union {
    char* str;
}

/* Token definitions */
%token DEPARTURES
%token <str> FLIGHT_NUMBER
%token <str> TIME
%token <str> AIRPORT
%token CARGO
%token FREIGHT

%type <str> optional_cargo

/* Grammar rules */
%%
input: DEPARTURES flights_list
    ;

flights_list: flights_list flight
    | /* empty */
    ;

flight: FLIGHT_NUMBER TIME AIRPORT optional_cargo
    {
        if ($4) {
            /* Store cargo flight */
            cargo_flights[cargo_flights_count++] = $1;
        } else {
            /* Count regular flights */
            if (is_before_noon($2)) {
                before_noon_count++;
            } else {
                after_noon_count++;
            }
            free($1);
        }
        free($2);
        free($3);
    }
    ;

optional_cargo: CARGO 
    { 
        $$ = "cargo"; 
    }
    | FREIGHT 
    { 
        $$ = "freight"; 
    }
    | /* empty */ 
    { 
        $$ = NULL; 
    }
    ;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error on line %d: %s\n", yylineno, s);
}

int main(int argc, char *argv[]) {
    /* Open input file if provided */
    if (argc > 1) {
        FILE *input_file = fopen(argv[1], "r");
        if (!input_file) {
            fprintf(stderr, "Cannot open input file %s\n", argv[1]);
            return 1;
        }
        yyin = input_file;
    }
    
    /* Parse the input */
    yyparse();
    
    /* Print the results */
    for (int i = 0; i < cargo_flights_count; i++) {
        printf("%s\n", cargo_flights[i]);
        free(cargo_flights[i]);
    }
    
    printf("number of flights before noon: %d\n", before_noon_count);
    printf("number of flights after noon: %d\n", after_noon_count);
    
    /* Close input file if opened */
    if (argc > 1) {
        fclose(yyin);
    }
    
    return 0;
}