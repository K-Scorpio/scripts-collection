#!/bin/bash

#This script will scan a network and extract the IP and MAC addresses in a file
#This script takes one argument, an ip address range

#Check if the required arguments were provided
if [ $# -ne 1 ]
then
	echo "Usage: $0 enter <ip_address_range>"
	exit 1
fi

#Create a directory to store the IP and MAC addresses 
mkdir -p ip_mac_addresses

echo "Scanning the network..."
#Scan the network and save the output in a file
sudo nmap -sn $1 > ip_mac_addresses/scan_output.txt
echo "Network scan complete."

echo "Extracting IP addresses..."
#Extract the IP addressesfrom the scan output
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" ip_mac_addresses/scan_output.txt > ip_mac_addresses/ip_addresses.txt
echo "IP addresses extracted."

echo "Extracting MAC addresses..."
#Extract the MAC addresses from the scan output
grep -oE "\b([0-9A-Fa-f]{1,2}\:){5}([0-9A-Fa-f]{1,2})\b" ip_mac_addresses/scan_output.txt > ip_mac_addresses/mac_addresses.txt
echo "MAC addresses extracted."

#Get the current date and time
date_time=$(date '+%Y-%m-%d_%H-%M-%S')

echo "Combining IP and MAC addresses..."
#Combine the IP and MAC addresses into a single file with two colums
paste ip_mac_addresses/ip_addresses.txt ip_mac_addresses/mac_addresses.txt > ip_mac_addresses/ip_mac_addresses_$date_time.txt
echo "IP and MAC addresses combined into one file."

echo "Cleaning up unnecessary files..."
# Cleanup unnecessary files
rm ip_mac_addresses/ip_addresses.txt
rm ip_mac_addresses/mac_addresses.txt
rm ip_mac_addresses/scan_output.txt
echo "Cleanup complete."

echo "Script execution complete."
