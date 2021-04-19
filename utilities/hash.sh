#!/bin/bash
hash=$0
file=$1
#Check input utente
if [ -z "$file" ]
then
	echo -e "[-] Inserisci un file\n[-] Esempio: $hash </home/user/test.txt>\n[-] Al termine si può inviare hash a VirusTotal per controllare se vi sono dei match"
#Funzione principale
else
	md5=$(md5sum $file | awk {'print $1'})
	sha1=$(sha1sum $file | awk {'print $1'})
	sha256=$(sha256sum $file | awk {'print $1'})
	URL="https://www.virustotal.com/gui/file/$sha256/detection"
	echo -e "\n[+] MD5: $md5"
	echo -e "[+] SHA1: $sha1"
	echo -e "[+] SHA256: $sha256"
	#Invio hash VirusTotal tramite browser
	echo -e "\nVuoi controllare hash su VirusTotal?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) break;;
			No ) echo -e "Bye!"; exit;;
		esac
	done
	#Controllo browser di default
	echo -e "\n[+] Ricerca dell'hash su VirusTotal\n[+] Al termine si aprirà scheda nel browser\n"
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