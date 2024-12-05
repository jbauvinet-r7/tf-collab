from scapy.all import IP, TCP, UDP, rdpcap, wrpcap

# Define a function to modify the IP addresses
def modify_ip(pkt):
    if IP in pkt:
        # Map old IPs to new IPs
        ip_mapping = {
            "10.0.0.61": "10.0.10.101",
            "10.0.0.31": "10.0.10.102",
            "10.0.0.80": "10.0.10.103",  # Add more mappings as needed
            "157.230.93.100": "3.14.181.140"  # Replace with the desired new C2 server IP redirector.itsatrap.monster
        }

        # Modify source IP if it matches one in the mapping
        if pkt[IP].src in ip_mapping:
            pkt[IP].src = ip_mapping[pkt[IP].src]

        # Modify destination IP if it matches one in the mapping
        if pkt[IP].dst in ip_mapping:
            pkt[IP].dst = ip_mapping[pkt[IP].dst]

        # Recalculate checksums
        del pkt[IP].chksum
        if TCP in pkt:
            del pkt[TCP].chksum
        elif UDP in pkt:
            del pkt[UDP].chksum

    return pkt

# Read the input pcap file
packets = rdpcap("/Users/jbauvinet/Documents/GitHub/tf-selabs-global-terraform/network_sensor/lateral_backup_c2_1hr copy.pcap")

# Modify the IP addresses in each packet
modified_packets = [modify_ip(pkt) for pkt in packets]

# Write the modified packets to a new pcap file
wrpcap("/Users/jbauvinet/Documents/GitHub/tf-selabs-global-terraform/network_sensor/output.pcap", modified_packets)

print("IP addresses modified and saved to output.pcap")