export ROOT_DIR=${PWD}

CC=cc

all: spectre

spectre: spectre.c
	ln -sf ../../lib/libspectre.so ./
	$(CC) -g -Wall spectre.c -o $@ \
		  -I../../include \
		  -L../../lib \
		  -Wl,-rpath='$$ORIGIN' \
		  -lspectre \

run: spectre
	./spectre

clean:
	rm -vrf *.o *.a *.so spectre

.PHONY: clean all run
