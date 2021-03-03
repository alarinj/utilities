#!/bin/bash
# This is a script designed to speed up nmap scans
# Append the IP you want to scan to the script in terminal
# Example: ./nmap.sh <TARGET_IP>
# You can change the script and add the commands you wish in the section down below.
ip=$1;
if  [ -z "$ip" ];
then
	echo "[-] Missing IP";
	echo "[-] Append the IP you want to scan to the script in terminal";
	echo "[-] Example: ./nmap.sh <TARGET_IP>";
else
	echo "[+] Checking ports:";
	echo "";
	nmap $ip -p- | grep -E '(open|closed|filtered|unfiltered)' | sed -n '1!p' > .open-ports.txt;
	echo '[+] Ports found:'; cat .open-ports.txt;
	cat .open-ports.txt | awk {'print $1'} |grep -o '[0-9]*' > .open-ports2.txt;
	echo "";
	echo "[+] Starting Nmap";
	nmap -sC -sV -p $(tr '\n' , <.open-ports2.txt) -oN "nmap-scan_$ip.txt" $ip;
	echo "";
	echo "[+] Task completed";
	echo "[+] Scan saved in ./nmap-scan_$ip.txt";
	echo "[+] Cleaning up";
	rm .open-ports*.txt;
	echo "[+] Removed temp files.";
	echo "[+] Goodbye";
fi