#include "pirni.h"
#include <netinet/ip.h>
#include <netinet/if_ether.h> 

int child_pid = 0;
/***********************************************
 * fprint_ascii_line() -
 * prints recieved data logfile in ASCII format
 * *********************************************/


/**********************************************
 * processPacket() -
 * 		Processes all packets recieved and
 * 		prints them.
 * *******************************************/
void processPacket(u_char *arg, const struct pcap_pkthdr* pkthdr, const u_char * packet)
{
//	FILE *fp;
	int i=0;
	int *counter = (int *)arg;
	
	//fp = fopen(outputFile, "a+");
	printf("Packet Count: %d\n", ++(*counter));
	printf("Recieved Packet Size: %d\n", pkthdr->len);
	printf("Payload:\n");
	for(i=i; i<pkthdr->len; i++)
	{
		if(isprint(packet[i]))
			printf("%c ", packet[i]);
		else
			printf(". ");
			
		if((i%16 == 0 && i!=0) || i==pkthdr->len-1)
			printf("\n");
	}
	
	return;
}

void initSniffer(char *bpf_filter)
{
	int				count=0;
	bpf_u_int32		netaddr=0, mask=0;		// To store network address and netmask
	struct bpf_program filter;			// To store the BPF filter program
	pcap_t			*descr = NULL;				// Network interface handler
	char			errbuf[PCAP_ERRBUF_SIZE];		// Error buffer
	char			*filterargv = bpf_filter;			// Filter supplied by end user
	
	memset(errbuf, 0, PCAP_ERRBUF_SIZE);
	
	printf("[+] Opening device %s\n", device);
	
	/* Open device in promiscious mode */
	descr = pcap_open_live(device, MAXBYTES2CAPTURE, 0, 512, errbuf);
	if(descr == NULL)
	{
		printf("[-] Couldn't open device %s: %s\n", device, errbuf);
		return;
	}
	
	/* Look up info from the capture device */
	if(pcap_lookupnet(device, &netaddr, &mask, errbuf) == -1) {
		printf("[-] Couldn't look up IPv4 network number and netmask for %s\n", device);
		return;
	}
		
	/* Compile filter expression into a BPF filter program */
	if(pcap_compile(descr, &filter, filterargv, 1, mask) == -1) {
		printf("[-]Couldn't parse filter\n");
		return;
	}

	/* Load the filter */
	if(pcap_setfilter(descr, &filter) == -1) {
		printf("[-]Couldn't install filter\n");
		return;
	}
	
	printf("[+] Setting filter: %s\n", filterargv);
	
	/* Loop forever & call processPacket() for every received packet */
	pcap_loop(descr, -1, processPacket, (u_char *)&count);
	
	return;
}
