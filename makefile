CC = gcc
CFLAGS = -Wall -g
TARGET = airport

# Default build target
all: $(TARGET)

# Link lex.yy.c and your top-down parser source
$(TARGET): lex.yy.c airport.c
	$(CC) $(CFLAGS) -o $(TARGET) lex.yy.c airport.c

# Generate lex.yy.c from airport.lex
lex.yy.c: airport.lex
	flex airport.lex

# Optional debug version (flex with debug info)
debug: airport.lex
	flex -d airport.lex
	$(CC) $(CFLAGS) -o $(TARGET) lex.yy.c airport.c

# Clean all generated files
clean:
	rm -f $(TARGET) lex.yy.c
	rm -r airport.dSYM

# Run the program on test file
test: $(TARGET)
	./$(TARGET) < test_airport.txt

.PHONY: all clean test debug