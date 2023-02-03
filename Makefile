CC=gcc
CFLAGS=-c -Wall

# Compile le programme
all: exec

main.o: main.c header.h
	$(CC) -c $< -o $@
abr.o: abr.c header.h 
	$(CC) -c $< -o $@
tab.o: tab.c header.h 
	$(CC) -c $< -o $@
exec: main.o abr.o tab.o
	$(CC) $^ -o $@
# Enlèves les fichiers binaires
clean:
	rm -f *.o main
# Enleves les ancien fichiers binaires, recompile le programme
re:	clean all
