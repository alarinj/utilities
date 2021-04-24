#!/bin/bash
ip=$1
function install_req {
	echo "[+] Installing required packages."
	sudo apt install nmap gobuster dirb
	exit
}
function main {
	fastscan
	gobuster_fun
	clean
	indepthscan
	clean
}
function help {
	echo -e "\nHELP:\nA simple script to automate reconnaissance.\nIt requires nmap, gobuster and dirb to be installed in the machine.\nYou'll need to run it as root for nmap to work properly.\nYou can use the argument --install to install the requirement softwares"
	usage
	exit
}
function usage {
	echo -e "\nUSAGE:\n\nrecon.sh 		<ip> or <hostname>\n"
	echo -e "Example: 		recon.sh 0.0.0.0 or recon.sh example.com\n"
}
function check {
	if [ -z "$ip" ] || [ "$ip" == "--help" ] || [ "$ip" == "-h" ]; then
		help
		usage
		exit
	elif [ "$ip" == "--install" ]; then
		install_req
	else
		main
	fi
}
function fastscan {
	echo "[+] Fast Scan: Checking most common ports.";
	echo "";
	nmap $ip  -n | grep -E '(open|closed|filtered|unfiltered)' | sed '1d' > .open-ports.txt;
	ipcheck=$(cat .open-ports.txt)
	if [ -z "$ipcheck" ]; then
		echo "[-] Host seems to be down."
		exit
	fi
	echo '[+] Ports found:'; cat .open-ports.txt;
	cat .open-ports.txt | awk {'print $1'} |grep -o '[0-9]*' > .open-ports2.txt;
	echo "";
	echo "[+] Starting service scan:";
	nmap -sC -sV -p $(tr '\n' , <.open-ports2.txt) -oN "nmap-fastscan_$ip.txt" $ip;
	echo "";
	echo "[+] Task completed.";
	echo "[+] Scan saved in $(pwd)/nmap-fastscan_$ip.txt";	
}
function gobuster_fun {
	cat .open-ports.txt | grep http | grep -o '[0-9]*' > .open-ports3.txt
	while read -r line; do 
		if [ "$line" = "443" ]; then
			echo "[+] Starting gobuster:";
			gobuster dir -k -u https://$ip -w /usr/share/dirb/wordlists/common.txt |tee "gobuster_port-$line-log_$ip.txt"
			echo "[+] Scan saved in $(pwd)/gobuster_port-$line-log_$ip.txt"
		elif [ "$line" = "80" ]; then
			echo "[+] Starting gobuster:";
			gobuster dir -u $ip -w /usr/share/dirb/wordlists/common.txt |tee "gobuster_port-$line-log_$ip.txt"
			echo "[+] Scan saved in $(pwd)/gobuster_port-$line-log_$ip.txt"
		else
			echo "[-] No http/https service found!";
		fi
	done < .open-ports3.txt	
}
function clean {
	echo "[+] Cleaning up.";
	rm .open-ports*.txt;
	echo "[+] Removed temp files.";
	echo "";	
}
function indepthscan {
	echo "[+] Initiating in depth scan."
	echo "[+] Checking ports. Don't worry, can take a while.";
	echo "";
	nmap $ip -p- -n -sV | grep -E '(open|closed|filtered|unfiltered)' | sed '1d' > .open-ports.txt;
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
}
check
echo "[+] Goodbye!"
