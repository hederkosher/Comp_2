CC = gcc
CFLAGS = -Wall -g
TARGET = airport

all: $(TARGET)

$(TARGET): lex.yy.c airport.c
	$(CC) $(CFLAGS) -o $(TARGET) lex.yy.c airport.c

lex.yy.c: airport.lex
	flex airport.lex

debug: airport.lex
	flex -d airport.lex
	$(CC) $(CFLAGS) -o $(TARGET) lex.yy.c airport.c

clean:
	rm -f $(TARGET) lex.yy.c

test: $(TARGET)
	./$(TARGET) < test_airport.txt

.PHONY: all clean test debug
