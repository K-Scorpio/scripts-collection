#!/bin/bash


if [ -z "$1" ]; then
  echo "Usage: $0 <target_ip> <output_file_name>"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Usage: $0 <target_ip> <output_file_name>"
  exit 1
fi

TARGET_IP="$1"
OUTPUT_FILE_NAME="$2"

if [ ! -d "nmap" ]; then
  mkdir nmap
fi

nmap_output=$(nmap $TARGET_IP -p- --min-rate=5000 -Pn --open --reason)

# The output of the first scan is saved for debugging purposes
echo "$nmap_output" > nmap_output.txt

ports=$(echo "$nmap_output" | grep -Eo '^[0-9]+/tcp[ ]+open' | awk '{print $1}' | cut -d'/' -f1 | paste -sd "," -)

if [ -n "$ports" ]; then
  echo "Running detailed scan on open ports: $ports"
  nmap -sC -sV -p $ports -oA nmap/$OUTPUT_FILE_NAME $TARGET_IP
else
  echo "No open ports found."
fi

