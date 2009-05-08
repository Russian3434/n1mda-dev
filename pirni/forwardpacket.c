#include "pirni.h"
#include "forwardpacket.h"

//void getHwAddrFromIP()
//{
	/* Create ARP header */
//	printf("[+] Creating ARP header\n");
//	arp_tag = libnet_build_arp(
//				1,						/* hardware type */
//				0x0800,					/* proto type */
//				6,						/* hw addr size */
//				4,						/* proto addr size */
//				ARP_REQUEST,			/* ARP OPCODE */
//				SrcHW,					/* source HW addr */
//				(u_char *)&SrcIP,		/* src proto addr */
//				DstHW,					/* dst HW addr */
//				(u_char *)&DstIP,		/* dst IP addr */
//				NULL,					/* no payload */
//				0,						/* payload length */
//				l,						/* libnet tag */
//				0);						/* ptag see man */
				

//	return;				
//}

void send_packet(char *protocol, int sport2, int dport2, int id, int ttl, int count, const u_char *payload, int payload_size)
{
	int packet_size;
	int ip_size;
	int udp_size;
	int tcp_size;
	int c;
	u_char *packet;	
	
	if(protocol == "udp")
	{
		packet_size = LIBNET_ETH_H + LIBNET_IP_H + LIBNET_UDP_H + payload_size;
		ip_size = LIBNET_IP_H + LIBNET_UDP_H + payload_size;
		udp_size = LIBNET_UDP_H + payload_size;
		
		if(libnet_init_packet(packet_size, &packet) == -1) {
			printf("[-] libnet_init_packet failed: %s\n",libnet_geterror(l));
		}
		
		/* Build ethernet header */
		libnet_build_ethernet(enet_dst,
							  enet_src,
							  ETHERTYPE_IP,
							  NULL,
							  0,
							  packet);
							  
		/* Build IP header */
		libnet_build_ip(LIBNET_UDP_H + payload_size,
						0,
						id,
						0,
						ttl,
						IPPROTO_UDP,
						inet_addr(saddr2),
						inet_addr(daddr2),
						payload,
						0,
						packet + LIBNET_ETH_H);
						
						
		/* Build UDP header */
		libnet_build_udp(sport2,
						 dport2,
						 payload,
						 payload_size,
						 packet + LIBNET_ETH_H + LIBNET_IP_H);
						 
						 
		/* Packet checksums (ICMP and IP header) */
		if(libnet_do_checksum(packet + ETH_H, IPPROTO_UDP, LIBNET_UDP_H + payload_size) == -1) {
			printf("[-] libnet_do_checksum failed: %s\n", libnet_geterror(l));
		}
		
		if(libnet_do_checksum(packet + ETH_H, IPPROTO_IP, LIBNET_IP_H) == -1) {
			printf("[-] libnet_do_checksum failed: %s\n", libnet_geterror(l));
		}
		
		
		/* TCP */
		
		
		
		
		
		/* PACKET INJECTION */
	c = libnet_write_link_layer(network, dev, packet, packet_size);
	if(c < packet_size) {
		printf("[*] libnet_write_link_layer only wrote %d/%d bytes\n", c, packet_size);
	}
	
	libnet_destroy_packet(&packet);
}
		
		
		
		
		
