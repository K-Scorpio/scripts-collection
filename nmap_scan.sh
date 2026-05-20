#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: $0 <target_ip> <output_file_name>"
}

if [ "$#" -ne 2 ]; then
  usage
  exit 1
fi

TARGET_IP="$1"
OUTPUT_FILE_NAME="$2"

if ! command -v nmap >/dev/null 2>&1; then
  echo "Error: nmap is not installed or not in PATH." >&2
  exit 1
fi

mkdir -p nmap

nmap_output=$(nmap "$TARGET_IP" -p- --min-rate=5000 -Pn --open --reason)

# The output of the first scan is saved for debugging purposes
printf '%s\n' "$nmap_output" > "nmap/${OUTPUT_FILE_NAME}_initial.txt"

ports=$(awk '/^[0-9]+\/tcp[[:space:]]+open/ {
  split($1, port, "/")
  open_ports = open_ports ? open_ports "," port[1] : port[1]
}
END {
  print open_ports
}' <<< "$nmap_output")

if [ -n "$ports" ]; then
  echo "Running detailed scan on open ports: $ports"
  nmap -sC -sV -p "$ports" -oA "nmap/$OUTPUT_FILE_NAME" "$TARGET_IP"
else
  echo "No open ports found."
fi
