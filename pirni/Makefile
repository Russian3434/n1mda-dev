#CC=/home/n1mda/sdk2/toolchain/toolchain/pre/bin/arm-apple-darwin9-gcc
CC=arm-apple-darwin9-gcc
CFLAGS=-Wall -pthread -lpcap

main: pirni.c
	$(CC) $(CFLAGS) pirni.c threads.c sniffer.c -o pirni -lnet
#	ldid -S pirni
clean:
	rm -f pirni pirno.o threads.o sniffer.o
