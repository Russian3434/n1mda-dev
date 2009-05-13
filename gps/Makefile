CC=arm-apple-darwin9-gcc 
LD=$(CC) 
SDK=/home/n1mda/toolchain/sdks/iPhoneOS2.2.1.sdk
LDFLAGS=-bind_at_load -lobjc -framework CoreFoundation -framework Foundation -framework AVFoundation -framework CoreLocation -framework IOKit -framework AppSupport -w

IP=192.168.0.184

all: gps

gps: main.o DLocationDelegate.m
	$(LD) $(LDFLAGS) -v -o $@ $^ 

%.o: %.m 

	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@ 

transfer: all
	ssh mobile@$(IP) "rm -rf gps"
	scp gps mobile@$(IP):~/
	ssh mobile@$(IP) "ldid -S gps"

clean: 

	rm -f *.o gps
