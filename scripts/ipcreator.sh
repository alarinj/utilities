#!/bin/bash
nip=$1
file=./iplist.txt
re='^[0-9]+$'
function help {
	echo "Simple tool to create ips."
	echo "Usage: Append a number to the script do generate that much ips and have them saved in your current location."
	echo "Example: $0 50"
}
function check {
	if [ -z "$nip" ] || [ "$nip" == "--help" ] || [ "$nip" == "-h" ]; then
		help
		exit
	elif ! [[ $nip =~ $re ]] ; then
		help
		exit
	else
		checkfile

	fi
}
function createip {
	for (( c=1; c<=$nip; c++ ));do
		pos1=$((1 + $RANDOM % 254))
		pos2=$((1 + $RANDOM % 254))
		pos3=$((0 + $RANDOM % 254))
		pos4=$((1 + $RANDOM % 254))
		ip=$(echo "$pos1.$pos2.$pos3.$pos4")
		echo "$ip"
		echo "$ip" >> iplist.txt
	done
}
function checkfile {
	if [ -f "$file" ]; then
		rm iplist.txt
		createip
	else
		createip
	fi
}
check