### Do you like pirni? check out Pirni Pro! ###
[www.rootateverything.com](http://www.rootateverything.com)

# Introduction #

Pirni is the worlds first native network sniffer for iPhone.
The iPhone's wifi has some major drawbacks in it's hardware design, thus we can not properly set the device in promiscious mode.
This is why pirni comes with an ARP spoofer that successfully routes all the network traffic through your device and then uses packet forwarding to send it to it's normal recipent (ie. the router)

After a successful network sniffing, you can transfer the dumpfile to your computer and open it up with Wireshark (or any other traffic analyzer that supports pcap) to analyze the traffic.

![http://n1mda-dev.googlecode.com/svn/wiki/pirni.jpg](http://n1mda-dev.googlecode.com/svn/wiki/pirni.jpg)

### Usage: ###
```
pirni [Options] -s <source_ip> -o <logfile>

```

OPTIONS:

**-i:** Specifies the interface that you should initialize. In most cases you don't have to supply this, it will automatically choose en0. But if the interface is called something different on your device (perhaps en1), you would have to supply it.

**-s:** Specifies the IP-adress you want to spoof, most likely the default gateway/router

**-d:** Specifies the target you want to perform MITM on. Broadcast IP (entire network) will be used if nothing else is supplied

**-f:** Specifies the Berkley Packet Filter so that pirni only collects interesting packets. This is very good if you want to filter out specific packets - such as FTP, SMTP or HTTP. If no -f options is supplied, all packets will be captured.

**-o:** Specifies the dumpfile where all the collected packets end up. This is a pcap dump format, that most  traffic analyzers can handle.

```
EXAMPLES:
        pirni -s 192.168.0.1 -o log.pcap
        pirni -s 192.168.0.1 -d 192.168.0.128 -f "tcp dst port 80" -o log.pcap
        pirni -i en1 -s 192.168.0.1 -d 255.255.255.0 -o log.pcap
```



## BPF Filters ##
BPF filters allow you to select which packets to be dumped. This allows you to "filter" packets, so that only "interesting" packets can be supplied to the software using BPF; this can avoid copying "uninteresting" packets from the operating system kernel to software running in user mode, reducing the CPU requirement to capture packets and the buffer space required to avoid dropping packets.

A full guide of available BPF filters is available here: http://www.cs.ucr.edu/~marios/ethereal-tcpdump.pdf (PDF 76.75Kb)

### Examples ###
To print all packets arriving at or departing from sundown:

_"host sundown"_

To print traffic between helios and either hot or ace:

_"host helios and ( hot or ace )"_

To print all IP packets between ace and any host except helios:

_"ip host ace and not helios"_

To print the start and end packets (the SYN and FIN packets) of each TCP conversation that involves a non-local host:

_"tcp[tcpflags](tcpflags.md) & (tcp-syn|tcp-fin) != 0 and not src and dst net localnet"_

To print IP packets longer than 576 bytes sent through gateway snup:

_"gateway snup and ip[2:2] > 576"_

To print IP broadcast or multicast packets that were not sent via ethernet broadcast or multicast:

_"ether[0](0.md) & 1 = 0 and ip[16](16.md) >= 224"_

To print all ICMP packets that are not echo requests/replies (i.e., not ping packets):

_"icmp[icmptype](icmptype.md) != icmp-echo and icmp[icmptype](icmptype.md) != icmp-echoreply"_

## External documents ##
  * iPod touch iPhone password sniffing: http://www.youtube.com/watch?v=Laf1f5uQz3I
  * Italian user guide: https://www.ihteam.net/blog/hacking-news/pirni-il-primo-sniffer-per-iphone/

## TODO (future versions) ##
  * Implement pcap dump format (this will probably be available within a week or two and will allow you to analyze the traffic in wireshark or any other program that supports the pcap format) **DONE**