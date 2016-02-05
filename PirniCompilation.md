# Introduction #

This document is about the two ways you can compile pirni, both ON your iPhone or cross compiling with the toolchain. If anyone wants to add instructions for the SDK, go ahead and leave a comment :)


**If you're in no need to compile your own version, pirni is available in the [BigBoss](http://www.thebigboss.org) repository on Cydia. Tap and install, that's it**

## Native way - On your iPhone ##
Download the latest sources from this subversion:
```
svn checkout http://n1mda-dev.googlecode.com/svn/trunk/pirni/ pirni
```

Transfer all the files to your iPhone and SSH in to it (or do it locally with mobileterminal)

**Currently in firmware 3.0 libgcc has not yet been ported and compiling ON the iphone is not available. If you are on 2.2.1 or lower it will work though.**

In order to compile you need to install _libnet_ and _libpcap_ from Cydia. You also need to codesign the binary with ldid. You might have to change your settings to "Hacker" in order for these packages to show up in the Cydia listings. You may also install them directly from the command line:

```
sudo apt-get install gcc libnet libpcap ldid
```
```
cd pirni
make
ldid -S pirni
sudo cp pirni /usr/bin/
```

You can now delete the source from your device. Done.

## Cross compilation: arm-apple-darwin9-gcc ##
In order to compile with the cross-compiler you need the libnet and libpcap libraries and headers.

Copy
**/usr/include/libnet`*`**
**/usr/lib/libnet.dylib**
**/usr/include/lipcpap`*`**
**/usr/lib/libpcap.dylib**

into your toolchain path.
When compiling with arm-apple-darwin9-gcc use -lnet -lpcap

As far as I know, you can compile it using the Apple SDK as well, but I get permission errors from libnet as the Apple code signing disables the binaries ability to setuid(0)