
game:
	cobc -x flapper.cbl raylib.c -lraylib -lGL -lm -lpthread -ldl -lrt -lX11 -o flapper

clean:
	rm -f flapper
