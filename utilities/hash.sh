#!/bin/bash
hash=$0
file=$1
#Check user input
if [ -z "$file" ]
then
	echo -e "[-] Add a file\n[-] Example: $hash </home/user/test.txt>\n[-] When the ccalculation is done, it's possible to sent the hash to VirusTotal to check it"
#Main function
else
	md5=$(md5sum $file | awk {'print $1'})
	sha1=$(sha1sum $file | awk {'print $1'})
	sha256=$(sha256sum $file | awk {'print $1'})
	URL="https://www.virustotal.com/gui/file/$sha256/detection"
	echo -e "\n[+] MD5: $md5"
	echo -e "[+] SHA1: $sha1"
	echo -e "[+] SHA256: $sha256"
	#Send hash via browser
	echo -e "\nWant to check the hash on VirusTotal?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) break;;
			No ) echo -e "Bye!"; exit;;
		esac
	done
	#Check default browser
	echo -e "\n[+] Sending the hash to VirusTotal.\n[+] The search will appear on the browser.\n"
	sleep 1
	if which xdg-open > /dev/null
	then
  		xdg-open "$URL"
	elif which gnome-open > /dev/null
	then
  		gnome-open "$URL"
  	elif which gnome-www-browser > /den/null
  	then
  		gnome-www-browser "$URL"
	fi
fi
