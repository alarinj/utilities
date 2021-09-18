#!/bin/bash
hash=$0
file=$1
function finishing {
	echo -e "Analisi del file $file terminata"
	exit
}
function savefile {
	echo -e "File esaminato: $file" >> "$file.txt"
	echo -e "\nHASHES:" >> "$file.txt"
	echo -e "MD5: $md5" >> "$file.txt"
	echo -e "SHA1: $sha1" >> "$file.txt"
	echo -e "SHA256: $sha256" >> "$file.txt"
	echo -e "\nMETADATA:\n$exif" >> "$file.txt"
	echo -e "[+] Dati salvati nel file $file.txt"
	virustotal
}
function virustotal {
	URL="https://www.virustotal.com/gui/file/$sha256/detection"
	echo ""
	read -p "[+] Vuoi controllare hash su VirusTotal? y/n: " yn
	while true; do
		case $yn in
			[Yy]* ) break ;;
			[Nn]* ) finishing ;;
			*) echo "Rispondere con y per sì e n per no";virustotal ;;
		esac
	done
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
	finishing
}
function hashes {
	md5=$(md5sum $file | awk {'print $1'})
	sha1=$(sha1sum $file | awk {'print $1'})
	sha256=$(sha256sum $file | awk {'print $1'})
	exif=$(exiftool $file)
	echo -e "\n[+] MD5: $md5"
	echo -e "[+] SHA1: $sha1"
	echo -e "[+] SHA256: $sha256"
	echo -e "[+] Metadata:\n$exif"
	echo ""
	read -p "[+] Vuoi salvare l'output su un file? y/n: " yn
	while true; do
		case $yn in
			[Yy]* ) savefile ;;
			*) virustotal ;;
		esac
	done
}
#Check input utente
if [ -z "$file" ]
then
	echo -e "[-] Inserisci un file\n[-] Esempio: $hash </home/user/test.txt>\n[-] Al termine si può inviare hash a VirusTotal per controllare se vi sono dei match"
#Funzione principale
else
	hashes
fi
