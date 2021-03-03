#!/bin/bash
# This is a script designed to speed up nmap scans
# Append the IP you want to scan to the script in terminal
# Example: ./nmap.sh <TARGET_IP>
# You can change the script and add the commands you wish in the section down below.
# First scan is gonna check for the most common ports, second one is gonna be on the full port range
ip=$1;
if  [ -z "$ip" ];
then
	echo "[-] Missing IP.";
	echo "[-] Append the IP you want to scan to the script in terminal.";
	echo "[-] Example: ./nmap.sh <TARGET_IP>.";
else
	echo "[+] Fast Scan: Checking most common ports.";
	echo "";
	nmap $ip  -n | grep -E '(open|closed|filtered|unfiltered)' | sed '1d' > .open-ports.txt;
	echo '[+] Ports found:'; cat .open-ports.txt;
	cat .open-ports.txt | awk {'print $1'} |grep -o '[0-9]*' > .open-ports2.txt;
	echo "";
	echo "[+] Starting service scan:";
	nmap -sC -sV -p $(tr '\n' , <.open-ports2.txt) -oN "nmap-fastscan_$ip.txt" $ip;
	echo "";
	echo "[+] Task completed.";
	echo "[+] Scan saved in ./nmap-fastscan_$ip.txt";
	echo "[+] Cleaning up.";
	rm .open-ports*.txt;
	echo "[+] Removed temp files.";
	echo "";
	echo "[+] Initiating in depth scan."
	echo "[+] Checking ports. Don't worry, can take a while.";
	echo "";
	nmap $ip -p- -n | grep -E '(open|closed|filtered|unfiltered)' | sed '1d' > .open-ports.txt;
	echo '[+] Ports found:'; cat .open-ports.txt;
	cat .open-ports.txt | awk {'print $1'} |grep -o '[0-9]*' > .open-ports2.txt;
	echo "";
	echo "[+] Starting service scan:";
	nmap -sC -sV -p $(tr '\n' , <.open-ports2.txt) -oN "nmap-indepthscan_$ip.txt" $ip;
	echo "";
	echo "[+] Task completed.";
	echo "[+] Scan saved in ./nmap-indepthscan_$ip.txt";
	echo "[+] Cleaning up.";
	rm .open-ports*.txt;
	echo "[+] Removed temp files.";
	echo "[+] Goodbye!";
fi