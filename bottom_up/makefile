CC=gcc
CFLAGS=-Wall -g

all: airport

airport: lex.yy.c airport.tab.c airport.tab.h
	$(CC) $(CFLAGS) -o airport lex.yy.c airport.tab.c -L/usr/local/opt/flex/lib -ll

lex.yy.c: airport.lex airport.tab.h
	flex airport.lex

airport.tab.c airport.tab.h: airport.y
	bison -d airport.y

clean:
	rm -f lex.yy.c airport.tab.c airport.tab.h airport