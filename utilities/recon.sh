#!/bin/bash
ip=$1
if  [ -z "$ip" ];
then
	echo "[-] Missing IP.";
	echo "[-] Append the IP you want to scan to the script in terminal.";
	echo "[-] Example: $0 <TARGET_IP>.";
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
	echo "[+] Scan saved in $(pwd)/nmap-fastscan_$ip.txt";
	cat .open-ports.txt | grep http | grep -o '[0-9]*' > .open-ports3.txt
	while read -r line; do 
		if [ "$line" = "443" ]; then
			echo "[+] Starting gobuster"
			gobuster dir -k -u https://$ip -w /usr/share/dirb/wordlists/common.txt |tee "gobuster_port-$line-log_$ip.txt"
			echo "[+] Scan saved in $(pwd)/gobuster_port-$line-log_$ip.txt"
		elif [ "$line" = "80" ]; then
			echo "[+] Starting gobuster"
			gobuster dir -u $ip -w /usr/share/dirb/wordlists/common.txt |tee "gobuster_port-$line-log_$ip.txt"
			echo "[+] Scan saved in $(pwd)/gobuster_port-$line-log_$ip.txt"
		else
			echo "[-] No http/https service found"
			break
		fi
	done < .open-ports3.txt
	echo "[+] Cleaning up.";
	rm .open-ports*.txt;
	echo "[+] Removed temp files.";
	echo "";
	echo "[+] Initiating in depth scan."
	echo "[+] Checking ports. Don't worry, can take a while.";
	echo "";
	nmap $ip -p- -n | grep -E '(open|closed|filtered|unfiltered)' | sed '1d' > .open-ports.txt;
	cp ./.open-ports.txt open_ports_$ip.txt;
	echo '[+] Ports found:'; cat .open-ports.txt;
	echo "[+] Ports saved in $(pwd)/open_ports_$ip.txt";
	cat .open-ports.txt | awk {'print $1'} |grep -o '[0-9]*' > .open-ports2.txt;
	echo "";
	echo "[+] Starting service scan:";
	nmap --script="default,safe" -sV -p $(tr '\n' , <.open-ports2.txt) -oN "nmap-indepthscan_$ip.txt" $ip;
	echo "";
	echo "[+] Task completed.";
	echo "[+] Scan saved in $(pwd)/nmap-indepthscan_$ip.txt";
	echo "[+] Cleaning up.";
	rm .open-ports*.txt;
	echo "[+] Removed temp files.";
	echo "[+] Goodbye!";
fi
