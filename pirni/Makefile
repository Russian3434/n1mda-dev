CC=gcc
CFLAGS=-Wall -lnet -pthread -lpcap

main: pirni.c
	$(CC) $(CFLAGS) pirni.c threads.c sniffer.c -o pirni
clean:
	rm -f iphonearp iphonearp.o threads.o
