CC=arm-apple-darwin9-gcc 
LD=$(CC) 
SDK=/home/n1mda/toolchain/sdks/iPhoneOS2.2.1.sdk
LDFLAGS=-bind_at_load -lobjc -framework CoreFoundation -framework Foundation -framework AVFoundation -framework AudioToolbox -w

IP=192.168.0.184

all: Playback

Playback: main.o PlayerDelegate.m
	$(LD) $(LDFLAGS) -v -o $@ $^ 

%.o: %.m 

	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@ 

transfer: all
	ssh mobile@$(IP) "rm -rf Playback"
	scp Playback mobile@$(IP):~/
	ssh mobile@$(IP) "ldid -S Playback"

clean: 

	rm -f *.o Playback
