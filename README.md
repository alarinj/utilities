## Utilities
* This is a small collection of utilities i made to automate some process during pentests.
* There are 3 main files, hash.sh recon.sh and shellcreator.sh.

## Hash.sh
* Is a simple script to calculate the md5 sha1 and sha256 sum of a given file.
* It's also possible to submit the 256 calculated hash to VirusTotal to check if it's present in their database.
* It can save the output, if needed
* Usage: hash.sh file_name

## Recon.sh
* This is a scritp to perform a basic recon of a given ip.
* It will perform a basic nmap discovery, if it finds open ports on 80 or 443 it will then perform a gobuster dir bruteforce on the site, and than it will perform an nmap analysis an all the ports.
* All the logs will be saved into the current directory, in txt format.
* Usage: recon.sh ip_to_scan

## Shellcreator.sh
* This script will generate a reverse shell and open a listener.
* It can create a reverse shell for bash, nc and php.
* It accepts 2 flags, -i and -s, the first one to supply a network interface, the second one to select the type of shell; -h is also avaible for a full instructions output.
* This script requires xclip to function properly. You can install it using the following command: ```sudo apt install xclip```
* Usage: shellcreator.sh -i <network_interface> -s <type_of_shell>
## Ipcreator.sh
* A small script to create a list of ips, usefull for decoys in nmap and similar tools
* Usage: ipcreator.sh <number_of_ips_to_create>
* Example: ```ipceator.sh 100```
