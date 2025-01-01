#!/bin/bash

# Check if an IP address is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

IP=$1
OUTPUT_FILE="nmap_scan"

# Step 1: Perform a full port scan with high speed and parse open ports
echo "[*] Performing full port scan on $IP..."
ports=$(nmap -p- --min-rate=1000 -T4 "$IP" | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)

if [ -z "$ports" ]; then
    echo "[!] No open ports found on $IP."
    exit 1
fi

echo "[*] Open ports found: $ports"

# Step 2: Perform detailed scan on the open ports
echo "[*] Performing detailed scan on $IP..."
nmap -p"$ports" -sC -sV -oA "$OUTPUT_FILE" "$IP"

echo "[*] Scan complete. Results saved to ${OUTPUT_FILE}.nmap, ${OUTPUT_FILE}.xml, and ${OUTPUT_FILE}.gnmap."
