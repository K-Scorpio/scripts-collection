#!/bin/bash


# Change the IP address accordingly
TARGET_IP="10.10.212.189"

nmap_output=$(nmap $TARGET_IP -p- --min-rate=5000 -Pn --open --reason)

# The output of the first scan is saved for debugging purposes
echo "$nmap_output" > nmap_output.txt

ports=$(echo "$nmap_output" | grep -Eo '^[0-9]+/tcp[ ]+open' | awk '{print $1}' | cut -d'/' -f1 | paste -sd "," -)

if [ -n "$ports" ]; then
  echo "Running detailed scan on open ports: $ports"
  nmap -sC -sV -p $ports -oA nmap/CyberLens $TARGET_IP
else
  echo "No open ports found."
fi
